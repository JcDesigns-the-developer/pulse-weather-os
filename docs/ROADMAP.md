# Implementation roadmap

## Milestone 1 — repository and OS foundation
- [x] Establish Debian Live Build configuration and a package manifest.
- [x] Add a guarded build helper that refuses non-Debian-13 hosts and verifies the ISO artifact.
- [x] Record Supercell Wx upstream provenance and weather-safety requirements.
- [ ] Validate configuration and build a live ISO on a clean Debian 13 runner.

## Milestone 2 — actual radar application
- [ ] Pin a reviewed Supercell Wx upstream revision and document its build dependencies.
- [ ] Build/package the upstream C++/Qt application in CI.
- [ ] Test real radar ingestion and rendering using supported public data sources.
- [ ] Add Pulse branding and desktop launch integration without removing upstream functionality.

## Milestone 3 — official warning and tropical cyclone products
- [ ] Add resilient NWS alerts ingestion with expiration, deduplication, and source timestamps.
- [ ] Add NHC advisory/forecast-track ingestion with clear official-product provenance.
- [ ] Add parser tests and stale/offline indicators.

## Milestone 4 — experimental storm analysis
- [ ] Implement testable storm-object tracking and polygon geometry.
- [ ] Show source frame, timestamp, algorithm version, and evidence for every experimental polygon.
- [ ] Never describe radar signatures as deterministic tornado predictions.

## Milestone 5 — field tools and release engineering
- [ ] Satellite, surface observation, lightning-provider, and local HTTP/MQTT station integrations.
- [ ] Archive/replay, diagnostics, settings, and export.
- [ ] CI tests, package validation, BIOS/UEFI VM tests, checksums, and release notes.
