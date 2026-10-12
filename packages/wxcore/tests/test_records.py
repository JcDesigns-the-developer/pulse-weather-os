"""Tests for Pulse Weather OS shared data contracts."""

import unittest
from datetime import datetime, timedelta, timezone

from wxcore import DataClass, DataRecord, DataStatus


class DataRecordTests(unittest.TestCase):
    def setUp(self) -> None:
        self.now = datetime.now(timezone.utc)

    def make_record(self, **changes) -> DataRecord:
        values = {
            "source_id": "test-provider",
            "product_id": "sample-product",
            "data_class": DataClass.OBSERVATION,
            "status": DataStatus.FRESH,
            "retrieved_at": self.now,
        }
        values.update(changes)
        return DataRecord(**values)

    def test_rejects_naive_retrieval_timestamp(self) -> None:
        with self.assertRaisesRegex(ValueError, "timezone-aware"):
            self.make_record(retrieved_at=datetime(2026, 1, 1))

    def test_normalizes_timestamp_to_utc(self) -> None:
        offset = timezone(timedelta(hours=-4))
        local_time = datetime(2026, 10, 12, 12, 0, tzinfo=offset)
        record = self.make_record(retrieved_at=local_time)
        self.assertEqual(record.retrieved_at.utcoffset(), timedelta(0))
        self.assertEqual(record.retrieved_at.hour, 16)

    def test_geometry_requires_explicit_crs(self) -> None:
        with self.assertRaisesRegex(ValueError, "crs is required"):
            self.make_record(geometry={"type": "Point", "coordinates": [-81, 28]})

    def test_experimental_records_are_labeled(self) -> None:
        record = self.make_record(data_class=DataClass.EXPERIMENTAL)
        self.assertIn("experimental", record.quality)

    def test_expiry_is_not_guessed_when_missing(self) -> None:
        self.assertFalse(self.make_record().is_expired)

    def test_expired_record_is_detected(self) -> None:
        record = self.make_record(expires_at=self.now - timedelta(minutes=1))
        self.assertTrue(record.is_expired)

    def test_unavailable_record_is_not_usable(self) -> None:
        record = self.make_record(status=DataStatus.UNAVAILABLE)
        self.assertFalse(record.is_usable)

    def test_serialization_uses_utc_z_suffix(self) -> None:
        result = self.make_record().to_dict()
        self.assertTrue(result["retrieved_at"].endswith("Z"))
        self.assertEqual(result["data_class"], "observation")


if __name__ == "__main__":
    unittest.main()
