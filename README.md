# Pulse Weather OS

Pulse Weather OS is a Debian 13 (Trixie)-based meteorology workstation for live NEXRAD radar, severe-weather analysis, tropical cyclone monitoring, forecasting, observations, field operations, and briefing production.

**Current status: early development foundation.** This branch is not yet a bootable release. No ISO is published until a reproducible build has completed and been tested.

## Design goals

- Conventional LXQt desktop, SDDM login, NetworkManager, PipeWire, Firefox ESR, QTerminal, and PCManFM-Qt.
- Use the real [Supercell Wx](https://github.com/dpaulat/supercell-wx) C++/Qt radar application as a reference and initial radar engine, preserving upstream functionality, notices, and license.
- Build a broader set of custom meteorology applications rather than treating one radar program as the whole product.
- Keep official NWS/NHC products, observations, model guidance, analyst annotations, and experimental analysis visibly distinct.
- Reproducible builds, documented data sources, automated tests, no mandatory telemetry, and no simulated data presented as live.

## Custom application suite

See [Custom Meteorology Application Suite](docs/CUSTOM_APP_SUITE.md) for the planned radar, storm analysis, warning, tropical, forecast/model, sounding, satellite, hydrology, marine, station, field reporting, briefing, archive, and diagnostic applications. See [Application Architecture](docs/APP_ARCHITECTURE.md) for shared data contracts, source provenance, cache behavior, and test requirements.

The first shared code package, `packages/wxcore`, implements a dependency-free weather-record envelope with timezone-aware timestamps, source classes, freshness status, and provenance fields. Its unit tests are included in CI. This does not yet mean the provider adapters or end-user apps are complete.

## Current status

The repository has the Debian Live Build foundation, a package manifest, guarded build helper, CI validation, application catalog, shared data contract, and unit tests. Supercell Wx integration, official data adapters, desktop applications, and ISO validation remain in progress. Track work in [the roadmap](docs/ROADMAP.md).

## Build on Debian 13

Install build dependencies:

```sh
sudo apt update
sudo apt install --yes live-build git ca-certificates
```

From the repository root:

```sh
sudo bash ./scripts/build-iso.sh
```

The helper checks for Debian 13 and required tools, runs live-build, and verifies that a non-empty ISO exists before writing a SHA-256 checksum. It does not claim success unless the artifact is present.

Use a clean Debian 13 VM with ample disk space and RAM. This configuration has not yet been validated by a complete ISO build. Do not treat the resulting image as release-ready until BIOS/UEFI boot, networking, desktop login, live-session behavior, and installation have been tested.

## Supercell Wx upstream

Upstream project: https://github.com/dpaulat/supercell-wx  
Upstream documentation: https://supercell-wx.readthedocs.io/

Upstream describes Supercell Wx as a C++/Qt application for live and archived NEXRAD Level 2/Level 3 data and severe-weather alerts. Pulse Weather OS will integrate the actual application rather than substitute a web mockup. Upstream code remains subject to its own copyright, license, and third-party dependency terms.

## Safety and data integrity

- Radar signatures are evidence, not proof of a tornado on the ground.
- Experimental detections and extrapolated polygons must be labeled experimental and include timestamps and provenance.
- Official NWS alerts and NHC forecast products must remain visibly distinct from experimental analysis.
- Do not add credentials, API keys, private tokens, or user-specific configuration to source control.

## License

Original project code is intended to be MIT-licensed. Third-party code, artwork, fonts, data, and dependencies retain their respective licenses and attribution requirements. See `THIRD_PARTY_NOTICES.md`.
