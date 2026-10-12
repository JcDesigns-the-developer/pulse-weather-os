"""Normalized, provenance-aware weather records.

Adapters should normalize provider payloads into this contract before exposing
records to user interfaces or analysis algorithms. This module deliberately has
no network client or provider-specific assumptions.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from enum import Enum
from typing import Any, Mapping


class DataClass(str, Enum):
    """Authority/source category used to keep unlike data visually distinct."""
    OFFICIAL_PRODUCT = "official_product"
    OBSERVATION = "observation"
    MODEL_GUIDANCE = "model_guidance"
    ANALYST_CONTENT = "analyst_content"
    EXPERIMENTAL = "experimental"


class DataStatus(str, Enum):
    """Local freshness/availability state; not a forecast quality score."""
    FRESH = "fresh"
    STALE = "stale"
    OFFLINE_CACHE = "offline_cache"
    INVALID = "invalid"
    UNAVAILABLE = "unavailable"


def _aware_utc(value: datetime | None, field_name: str) -> datetime | None:
    if value is None:
        return None
    if value.tzinfo is None or value.utcoffset() is None:
        raise ValueError(f"{field_name} must be timezone-aware")
    return value.astimezone(timezone.utc)


@dataclass(frozen=True, slots=True)
class DataRecord:
    """Common envelope for observations, official products, and derived data.

    Geometry coordinates and CRS are intentionally generic so provider adapters
    can use GeoJSON-like mappings without coupling this package to a GIS library.
    retrieved_at is always required and records when this system fetched or
    loaded the item; it must not be substituted for provider issue/valid time.
    """
    source_id: str
    product_id: str
    data_class: DataClass
    status: DataStatus
    retrieved_at: datetime
    issued_at: datetime | None = None
    valid_at: datetime | None = None
    expires_at: datetime | None = None
    units: str | None = None
    geometry: Mapping[str, Any] | None = None
    crs: str | None = None
    provenance: str | None = None
    adapter_version: str | None = None
    quality: tuple[str, ...] = ()
    attributes: Mapping[str, Any] | None = None

    def __post_init__(self) -> None:
        for field_name in ("source_id", "product_id"):
            value = getattr(self, field_name)
            if not isinstance(value, str) or not value.strip():
                raise ValueError(f"{field_name} must be a non-empty string")

        for field_name in ("retrieved_at", "issued_at", "valid_at", "expires_at"):
            value = _aware_utc(getattr(self, field_name), field_name)
            object.__setattr__(self, field_name, value)

        if self.geometry is not None and not self.crs:
            raise ValueError("crs is required when geometry is provided")

        if self.data_class is DataClass.EXPERIMENTAL:
            quality = tuple(self.quality)
            if "experimental" not in {item.casefold() for item in quality}:
                object.__setattr__(self, "quality", quality + ("experimental",))

    @property
    def is_expired(self) -> bool:
        """Return true only when an explicit expiry is in the past."""
        if self.expires_at is None:
            return False
        return self.expires_at < datetime.now(timezone.utc)

    @property
    def is_usable(self) -> bool:
        """Whether the record is structurally eligible for display/processing."""
        return self.status in {DataStatus.FRESH, DataStatus.STALE, DataStatus.OFFLINE_CACHE}

    def to_dict(self) -> dict[str, Any]:
        """Return a JSON-compatible representation with ISO-8601 timestamps."""
        def stamp(value: datetime | None) -> str | None:
            return value.isoformat().replace("+00:00", "Z") if value else None

        return {
            "source_id": self.source_id,
            "product_id": self.product_id,
            "data_class": self.data_class.value,
            "status": self.status.value,
            "retrieved_at": stamp(self.retrieved_at),
            "issued_at": stamp(self.issued_at),
            "valid_at": stamp(self.valid_at),
            "expires_at": stamp(self.expires_at),
            "units": self.units,
            "geometry": dict(self.geometry) if self.geometry is not None else None,
            "crs": self.crs,
            "provenance": self.provenance,
            "adapter_version": self.adapter_version,
            "quality": list(self.quality),
            "attributes": dict(self.attributes) if self.attributes is not None else None,
        }
