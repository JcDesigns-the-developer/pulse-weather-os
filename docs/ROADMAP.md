# Implementation roadmap

## Milestone 1 — repository and OS foundation
- [x] Establish Debian Live Build configuration and a package manifest.
- [x] Add a guarded build helper that refuses non-Debian-13 hosts and verifies the ISO artifact.
- [x] Record Supercell Wx upstream provenance and weather-safety requirements.
- [ ] Validate configuration and build a live ISO on a clean Debian 13 runner.

## Milestone 2 — shared application architecture
- [x] Define the meteorology application suite and delivery order in docs/CUSTOM_APP_SUITE.md.
- [x] Define shared provenance, timestamp, source-class, and stale-data contracts in docs/APP_ARCHITECTURE.md.
- [x] Implement the first dependency-free wxcore data-record contract and unit tests.
- [ ] Add provider adapter interfaces, cache policy, and shared map/geometry utilities.

## Milestone 3 — actual radar application
- [ ] Pin a reviewed Supercell Wx upstream revision and document its build dependencies.
- [ ] Build/package the upstream C++/Qt application in CI.
- [ ] Test real radar ingestion and rendering using supported public data sources.
- [ ] Add Pulse branding and desktop launch integration without removing upstream functionality.

## Milestone 4 — official warning and tropical cyclone products
- [ ] Add resilient NWS alerts ingestion with expiration, deduplication, and source timestamps.
- [ ] Add NHC advisory/forecast-track ingestion with clear official-product provenance.
- [ ] Add parser tests and stale/offline indicators.

## Milestone 5 — experimental storm analysis
- [ ] Implement testable storm-object tracking and polygon geometry.
- [ ] Show source frame, timestamp, algorithm version, and evidence for every experimental polygon.
- [ ] Never describe radar signatures as deterministic tornado predictions.

## Milestone 6 — field tools and release engineering
- [ ] Satellite, surface observation, lightning-provider, and local HTTP/MQTT station integrations.
- [ ] Archive/replay, diagnostics, settings, and export.
- [ ] CI tests, package validation, BIOS/UEFI VM tests, checksums, and release notes.
