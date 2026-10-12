# Pulse Weather OS

Pulse Weather OS is a Debian 13 (Trixie)-based meteorology workstation for live NEXRAD radar, severe-weather analysis, tropical cyclone monitoring, forecasting, observations, field operations, and briefing production.

**Current status: development foundation; no verified ISO release yet.** This branch combines the earlier meteorology app and shared-code work with a more customizable Debian Live Build and installer configuration.

## Desktop and base system

- Conventional LXQt desktop, SDDM, NetworkManager, PipeWire, Firefox ESR, QTerminal, and PCManFM-Qt.
- Debian 13 packages and Debian Live Build, rather than a private copy of the entire Debian source archive.
- Debian Installer in live-install mode, with conservative preseed defaults that do not choose a disk or automate partitioning.
- Configurable ISO metadata, installer settings, and package profiles.

## Customize the ISO

Edit `os/config/pulse-build.conf`. Select `PULSE_PACKAGE_PROFILE="base"`, `"meteorology"`, or `"developer"`. Add or remove always-installed packages in `os/config/package-lists/pulse-weather.list.chroot`; customize files in `os/config/includes.chroot/`; adjust safe installer defaults in `os/config/includes.installer/preseed.cfg`.

Build on a clean Debian 13 Trixie host:

```sh
sudo apt update
sudo apt install --yes live-build git ca-certificates
sudo bash ./scripts/build-iso.sh
```

The output name is controlled by `PULSE_IMAGE_NAME` and the script writes a SHA-256 checksum. A successful build has not yet been verified; do not treat an ISO as release-ready until BIOS/UEFI boot, networking, desktop login, live-session behavior, and installation have been tested.

## Meteorology application suite

See [Custom Meteorology Application Suite](docs/CUSTOM_APP_SUITE.md) for the planned radar, storm analysis, warning, tropical, forecast/model, sounding, satellite, hydrology, marine, station, field reporting, briefing, archive, and diagnostic applications. [Application Architecture](docs/APP_ARCHITECTURE.md) defines shared data contracts, provenance, cache behavior, and test requirements.

[Supercell Wx](https://github.com/dpaulat/supercell-wx) is the reference and intended initial radar engine—not the whole operating system. The actual upstream application has not yet been built or integrated.

The first shared code package, `packages/wxcore`, defines source classes, freshness status, timezone-aware timestamps, and provenance fields. Unit tests are part of the GitHub Actions workflow. Provider adapters and end-user weather apps remain in progress.

## Debian derivative design

See [Debian derivative strategy](docs/DEBIAN_DERIVATIVE.md) and [OS build customization](os/README.md). This project uses official Debian packages and a local Live Build configuration overlay; it does not pretend to maintain the full Debian source archive.

## Data integrity

- Official NWS/NHC products, observations, model guidance, analyst annotations, and experimental output remain visibly distinct.
- Radar signatures are evidence, not proof of a tornado on the ground.
- Experimental polygons must include source timestamps, provenance, and algorithm version.
- No simulated data may be represented as live.
- Do not commit credentials, API keys, or private tokens.

## License

Original project code is intended to be MIT-licensed. Third-party code, artwork, fonts, data, and dependencies retain their respective licenses and attribution requirements. See `THIRD_PARTY_NOTICES.md`.
