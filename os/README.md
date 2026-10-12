# Debian Live Build configuration

This directory is the Pulse Weather OS derivative configuration layered on top of official Debian 13 Trixie packages and Debian Live Build. It is intentionally **not** a forked copy of the entire Debian source archive: the build pulls signed Debian packages from Debian repositories and applies this project's configuration overlays. This keeps updates maintainable and the derivative easier to audit.

## Easy customization

Edit `config/pulse-build.conf` to change the OS label, target architecture, image name, installer mode, ISO metadata, and package profile. Supported profiles:

- `base` — desktop and essential utilities only.
- `meteorology` — base plus a scientific Python/geospatial stack.
- `developer` — base plus compilers, CMake/Ninja, Git, and Qt development packages.

The selected profile is temporarily activated during a build; the checked-in `.disabled` profile manifests remain inactive in normal live-build discovery. Edit `config/package-lists/pulse-weather.list.chroot` to add or remove always-installed packages. Files under `config/includes.chroot/` are copied into the live filesystem at their matching paths. Installer defaults live in `config/includes.installer/preseed.cfg`.

## Installer safety

The current installer mode installs the live system to disk. The included preseed only selects locale, keyboard, and UTC time. It deliberately does not choose a disk, partitioning method, password, or unattended installation. Keep disk operations interactive unless you explicitly design and test a safe unattended installer.

## Build

From the repository root:

```sh
sudo bash ./scripts/build-iso.sh
```

The build script reads `os/config/pulse-build.conf`, validates customization values, configures Debian Live Build, builds the ISO, and writes a SHA-256 checksum. It requires a clean Debian 13 Trixie host and has not yet been validated by a complete ISO build. Test BIOS and UEFI boot, live session, networking, and installation before distributing any image.

## Upstream references

- Debian source packages: https://sources.debian.org/
- Debian Live Build manual: https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html
- Debian Live Build source: https://salsa.debian.org/live-team/live-build
- Custom meteorology applications: `../docs/CUSTOM_APP_SUITE.md`
- Shared app architecture: `../docs/APP_ARCHITECTURE.md`
