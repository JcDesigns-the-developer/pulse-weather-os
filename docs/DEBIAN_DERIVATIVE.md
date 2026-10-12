# Debian base and customization strategy

Pulse Weather OS is a Debian derivative built with Debian Live Build, not a separate rewrite or an unmaintainable fork of all Debian source packages.

## Upstream model

- Base distribution: Debian 13 Trixie.
- Package source: signed Debian repositories; package versions and security updates remain governed by Debian's repositories.
- Image construction: Debian Live Build, with this repository providing package lists, installer preseed, filesystem overlays, and a small wrapper script.
- Desktop: LXQt, with conventional windowing and no custom compositor requirement.
- Installer: Debian Installer in live-install mode, configured through documented Live Build options and a conservative preseed.

Debian's full source archive is enormous and continuously maintained. This project references Debian source packages and builds from official packages; it does not copy the entire Debian source archive into this repository. A specific Debian package should only be vendored or patched when a concrete requirement and reproducible patch are documented. This avoids freezing security updates or implying that this repository maintains the entire Debian distribution.

## Customization layers

1. `os/config/pulse-build.conf`: high-level build settings.
2. `os/config/package-lists/`: base package list plus optional package profiles.
3. `os/config/includes.chroot/`: files included in the live filesystem.
4. `os/config/includes.installer/`: Debian Installer configuration and preseed.
5. `scripts/build-iso.sh`: validated build orchestration and checksum generation.
6. `docs/CUSTOM_APP_SUITE.md`, `docs/APP_ARCHITECTURE.md`, and `packages/wxcore/`: the custom meteorology app scope, shared architecture, and initial shared data code carried forward from the foundation branch.

## Safety and maintenance

Do not automate destructive partitioning by default. Never commit credentials. Keep Debian security repositories enabled. Pin or patch an upstream component only when there is a reproducible reason. Each app should have separate tests, provenance metadata, and a clearly documented implementation status.
