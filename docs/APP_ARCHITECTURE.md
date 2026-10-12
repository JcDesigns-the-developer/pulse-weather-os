# Application Architecture and Data Contracts

## Design

Pulse Weather OS should be a collection of focused applications with shared libraries and a small local service layer. The desktop remains Debian + LXQt. Do not create a custom compositor or force a browser-only interface.

Suggested source layout as applications are implemented:

```text
apps/
  weather-center/
  alert-desk/
  radar/
  storm-analysis/
  polygon-lab/
  warning-workbench/
  storm-replay/
  forecast-desk/
  model-viewer/
  sounding-lab/
  tropical-desk/
  satellite-desk/
  station/
  observation-map/
  briefing-studio/
  case-archive/
packages/
  wxcore/
    sources/
    models/
    time/
    units/
    geometry/
    cache/
    provenance/
    alerts/
tests/
  fixtures/
  unit/
  integration/
```

This is the intended architecture, not a claim that these directories are already populated.

## Shared record contract

Every data adapter should normalize provider data into records with, where applicable:

- `source_id`: stable adapter/provider identifier.
- `product_id`: provider product or dataset identifier.
- `retrieved_at`: UTC time the local application retrieved the record.
- `issued_at`: provider issuance time, when available.
- `valid_at`: time the record describes or is valid for.
- `expires_at`: official expiry, where provided.
- `geometry`: coordinates in an explicitly declared coordinate reference system.
- `units`: physical units, never implicit.
- `quality`: provider quality flags and local validation state.
- `provenance`: URL or product identifier, adapter version, and transformation history.
- `status`: fresh, stale, offline-cache, invalid, or unavailable.

Fields that do not apply to a data type may be omitted, but adapters must not invent provider timestamps or quality flags.

## Data-source classes

1. **Official products** — for example NWS alerts and NHC advisories/GIS files. Preserve official wording, issue/update/expiry information, and source links.
2. **Observations** — station measurements, METARs, radar measurements, satellite scans, and buoy data. Preserve observation/scan time and quality metadata.
3. **Model guidance** — deterministic and ensemble forecasts. Always show model, initialization cycle, forecast lead, and valid time.
4. **Analyst content** — annotations, manually drawn polygons, briefing text, and reports. Keep author and edit history.
5. **Experimental output** — algorithms and derived storm objects. Include algorithm version, input records, run time, confidence/limitations, and a visible experimental label.

These classes must not be merged visually in a way that implies they have equal authority.

## Network and cache behavior

- Use documented endpoints and published formats; prefer official APIs and bulk/GIS products over brittle page scraping.
- Set connection and read timeouts. Retry transient failures with bounded exponential backoff and jitter.
- Respect provider rate limits, caching headers, terms of use, and redistribution restrictions.
- Keep a last-known-good cache with retrieval time and stale badge. Do not relabel cached data as live.
- Provide explicit empty, loading, error, and offline states.
- Keep credentials out of source control, URLs, and logs. Prefer a desktop secret store when credentials are necessary.
- Keep adapters replaceable so a provider outage does not corrupt the common data model.

## Geometry and time

- Store timestamps as timezone-aware UTC values.
- Keep source coordinate reference system metadata; explicitly transform before overlay or distance calculations.
- Use robust geometry libraries for intersection, clipping, simplification, and GeoJSON I/O.
- Never infer an official warning boundary from an experimental storm polygon.
- Test antimeridian-crossing tropical tracks and coastal geometry edge cases.

## Testing strategy

- Unit-test parsers against saved, licensed fixtures and malformed responses.
- Test expired, updated, cancelled, duplicate, and out-of-order alerts.
- Test missing timestamps, malformed geometries, unit conversions, time-zone boundaries, and stale-cache behavior.
- Integration-test adapters with recorded fixtures by default; keep live-network smoke tests optional.
- Do not use synthetic data in a production view unless the UI explicitly marks it as demo/test data.
- Test offline launch, display scaling, keyboard navigation, and recovery after a source failure.

## Official source references

- NWS API documentation: https://www.weather.gov/documentation/services-web-api
- NHC GIS data and tropical cyclone products: https://www.nhc.noaa.gov/gis
- NWS/AWIPS public distribution information: https://www.weather.gov/cp/DownloadAWIPS
- Supercell Wx upstream: https://github.com/dpaulat/supercell-wx

NHC describes official GIS products including forecast tracks/cones, watches and warnings, wind fields/radii, arrival-time products, wind-speed probabilities, and storm-surge products. Use the official products when available rather than fabricating a cone or path from a single center point.
