# Pulse Weather OS — Custom Meteorology Application Suite

This document defines the native applications Pulse Weather OS is intended to ship. The suite is designed for a practical forecasting/severe-weather workstation, not a collection of decorative dashboards. Applications must work with real data, expose data age and provenance, and remain useful when a provider is offline.

## Desktop shell

### Pulse Weather Center
A lightweight LXQt-friendly launch and operations center. Shows active warnings, data-source health, recently opened workspaces, and shortcuts to installed tools. It must not become a second desktop environment or require a cloud account.

### Pulse Data Manager
Manages data endpoints, local cache limits, refresh intervals, proxy settings, API credentials stored in the desktop secret store, download queues, and diagnostics. Credentials never belong in repository files or logs.

### Pulse Alert Desk
A persistent warning/alert panel with audible options, acknowledgment, filters by hazard/area/severity, expiry handling, deduplication, source timestamp, update/cancel status, and a history view. Official NWS alerts must be distinguishable from third-party notices and experimental detections.

## Radar and severe weather

### Pulse Radar (Supercell Wx integration)
Use the real upstream Supercell Wx application as the initial radar engine/reference, retaining upstream behavior, licenses, and notices. Add Pulse-specific packaging and integration around it before changing upstream internals. Required capabilities:
- Live and archived NEXRAD Level II/III where supported by upstream and data availability.
- Site/product selection, tilt/elevation and volume/time navigation, range rings, map overlays, color tables, and clear product legends.
- Reflectivity, velocity, spectrum width, correlation coefficient, differential reflectivity, differential phase, and other products when available from the selected radar/product.
- Looping, pause/step, timestamp, radar/site metadata, data-age indicator, and missing-frame handling.
- Export selected frames and analysis annotations with source metadata.

### Pulse Storm Analysis
A separate, testable analysis application/service for storm-object identification and track continuity. Candidate diagnostics include mesocyclone-like velocity couplets, TVS-like signatures, hail environments, storm motion, rotational velocity proxies, divergence/convergence, and user-drawn storm annotations. Each diagnostic must show its algorithm, inputs, timestamp, confidence/limitations, and whether it is experimental. Do not claim to predict a tornado deterministically or infer ground truth from radar alone.

### Pulse Polygon Lab
Draws and edits geospatial polygons for analyst-defined areas and experimental storm-object footprints. Supports GeoJSON export/import, versioned edits, time history, map projection metadata, and visible source layers. Automatically generated shapes are labeled experimental and must never resemble official warning polygons without a clear label.

### Pulse Warning Workbench
A read-only analysis interface for official warning polygons and statements, with geometry, issue/expiration/update times, affected areas, source links, and change history. It must not issue or publish official warnings.

### Pulse Storm Replay
Time-synchronized radar and observation replay for case studies, storm reports, and post-event analysis. Can export a replay manifest so another analyst can reproduce the view.

## Forecast and model tools

### Pulse Forecast Desk
Combines point forecasts, grids, forecast discussions, watches/warnings, hourly forecasts, and selected model guidance. Clearly labels model guidance versus official forecasts. Includes a forecaster notebook, map annotations, and exportable briefing products.

### Pulse Model Viewer
Loads supported forecast model grids and ensembles from real providers, with valid time, initialization cycle, lead time, units, source, and missing-data handling. Initial scope should be limited to formats the implementation can genuinely parse (for example GRIB2 through a maintained library); do not display a static mock model map as live guidance.

### Pulse Sounding Lab
Skew-T/log-P and thermodynamic analysis from observed or model soundings. Planned diagnostics include CAPE/CIN, LCL/LFC/EL, precipitable water, lapse rates, bulk shear, storm-relative helicity, and hodographs, with units and source metadata. Results must be traceable to the sounding used.

### Pulse Mesoscale Desk
Surface boundaries, fronts, pressure tendencies, moisture convergence, instability, shear, and other mesoanalysis layers when supported by valid source data. Every computed field identifies its method and input dataset.

### Pulse Verification Lab
Compare forecast guidance with observations and archived events. Metrics and plots must state sample size, time range, valid-time matching rules, and known biases; avoid claiming skill from a small or cherry-picked sample.

## Tropical, satellite, and environmental tools

### Pulse Tropical Desk
Official NHC/CPHC advisories, forecast points and track, official forecast cone, wind radii/probabilities, watches/warnings, key messages, rainfall and surge products when published, and historical best tracks. Official track and cone are ingested from official products, not reconstructed from a guessed path. Optional user scenarios are shown separately from official forecasts.

### Pulse Satellite Desk
Displays supported real satellite imagery/products with channel, wavelength, scan time, projection, source, and latency. Supports visible/IR/water-vapor products and animation when source data permits. It must state when a channel is unavailable or stale.

### Pulse Lightning Desk
Provider-adapter architecture for lightning data. Displays source, detection type, coverage, timestamp, latency, and licensing/redistribution limits. No fabricated lightning strikes; no scraping or redistribution that violates a provider's terms.

### Pulse Hydro Desk
Rainfall, river/stream gauge, flood guidance, and official flood products when available. Distinguishes observed rainfall, estimated precipitation, forecast rainfall, and official flood warnings.

### Pulse Marine Desk
Marine forecasts, buoy observations, wave/wind guidance, coastal flood/surge products, and tropical impacts. Units, observation time, and source are visible.

### Pulse Climate Desk
Climate normals, station records, daily/monthly summaries, extremes, and anomaly maps using documented datasets. Quality flags and missing observations are preserved.

## Field observations and reporting

### Pulse Station
Local weather-station ingestion over supported serial, HTTP, MQTT, or file interfaces. Includes sensor health, calibration notes, one-minute and configurable aggregation, unit conversion, data gaps, and CSV/JSON export. Station data is labeled private/local unless the operator explicitly configures a permitted upload destination.

### Pulse Observation Map
Surface observations from supported public networks, with station metadata, plotting models, quality flags, METAR decoding where appropriate, and stale-report indicators.

### Pulse Spotter Log
Time-stamped, geolocated user reports with source, reporter attribution/permission, attachments, confidence, and verification status. Reports are not automatically treated as confirmed tornadoes or official reports.

### Pulse Chase Navigator
Field-oriented map with radar/storm positions, route planning, road overlays, weather hazards, safe stopping notes, mobile-friendly layout, and offline map/cache options where licensing permits. Navigation must not encourage driving into hazardous conditions or distract the driver.

### Pulse Field Recorder
Captures analyst notes, photos, audio, GPS/time metadata when explicitly enabled, and incident timelines. Offers exportable case packages with a manifest and checksums.

## Communications, presentation, and research

### Pulse Briefing Studio
Creates editable forecast briefings, map panels, timelines, captions, and printable/PDF outputs. Every imported graphic keeps source attribution and valid time. Templates should be clean, newsroom-friendly, and configurable rather than overly stylized.

### Pulse Weather Crawler
Builds screen crawlers from selected official warnings, forecast text, and analyst-written captions. Includes text-length previews, safe area guides, source attribution, and export formats. Does not silently convert experimental detections into official warning text.

### Pulse Audio Alerts
Optional spoken alert/forecast playback with configurable voices and volume, quiet hours, deduplication, and separate channels for official warnings and local experimental notifications. No alert audio is required for core system operation.

### Pulse Case Archive
Searches and organizes downloaded radar volumes, imagery, soundings, station logs, reports, notes, replay manifests, and briefing exports. Tracks source, download time, checksums, and license/retention notes.

### Pulse Developer Diagnostics
Data-source health, connection tests, application logs with secret redaction, parser diagnostics, cache inspection, version information, and exportable troubleshooting bundles.

## Engineering requirements shared by all applications

- Real data only in live views; sample fixtures are visibly marked as samples.
- Display valid time, retrieval time, provider, and stale/offline status wherever relevant.
- Use UTC internally; show UTC and/or local time with explicit timezone labels.
- Preserve units and quality flags. Never silently convert missing values to zero.
- All network I/O must have timeouts, retry/backoff, rate-limit handling, and cache behavior.
- Parsers and geometry algorithms need deterministic unit tests and representative fixtures.
- Exported files include provenance metadata; avoid leaking secrets or private location history.
- Official products, model guidance, observations, analyst annotations, and experimental output use distinct labels and visual styles.
- Applications degrade gracefully when offline and never substitute placeholder content while claiming it is live.
- Keyboard navigation, readable contrast, scalable UI, and conventional desktop behavior are required.

## Delivery order

1. Real radar engine integration and shared data/source health.
2. Official alert desk and warning workbench.
3. Tropical desk using official NHC GIS/advisory products.
4. Polygon lab and replay/archive foundations.
5. Observation map and local station app.
6. Sounding and model viewers.
7. Satellite, hydro, marine, lightning provider adapters.
8. Briefing, crawler, audio, field and verification tools.

This is a product scope, not a claim that every application is already implemented. Track implementation and tests in the roadmap and each application's own status page.
