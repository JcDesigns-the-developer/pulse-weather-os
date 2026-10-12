# Debian Live Build configuration

This directory contains the live-build configuration for Pulse Weather OS. The target is Debian 13 Trixie amd64 with LXQt and a conventional desktop session.

## Current scope

- BIOS and UEFI hybrid live image settings.
- LXQt, SDDM, NetworkManager, PipeWire, Firefox ESR, QTerminal, PCManFM-Qt, and basic utilities.
- Branding and additional first-boot/installer work will be added in follow-up milestones.

## Build

Run `sudo ../scripts/build-iso.sh` from this directory or `sudo ./scripts/build-iso.sh` from the repository root. The helper normalizes the working directory before invoking live-build.

This configuration is a development starting point, not a release certification. Installer behavior, boot modes, hardware support, and the resulting ISO must be tested before calling an image release-ready.
