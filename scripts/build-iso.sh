#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OS_DIR="$ROOT/os"
CONFIG_FILE="$OS_DIR/config/pulse-build.conf"

fail() {
  printf 'Pulse Weather OS build error: %s\n' "$*" >&2
  exit 1
}

[[ -f "$CONFIG_FILE" ]] || fail "missing customization file: $CONFIG_FILE"
# This is a project-owned shell configuration file. Edit it to customize builds.
# shellcheck source=os/config/pulse-build.conf
source "$CONFIG_FILE"

: "${PULSE_OS_NAME:?PULSE_OS_NAME must be set in config/pulse-build.conf}"
: "${PULSE_DISTRO:?PULSE_DISTRO must be set in config/pulse-build.conf}"
: "${PULSE_ARCH:?PULSE_ARCH must be set in config/pulse-build.conf}"
: "${PULSE_IMAGE_NAME:?PULSE_IMAGE_NAME must be set in config/pulse-build.conf}"
: "${PULSE_INSTALLER_MODE:?PULSE_INSTALLER_MODE must be set in config/pulse-build.conf}"
: "${PULSE_INSTALLER_GUI:?PULSE_INSTALLER_GUI must be set in config/pulse-build.conf}"
: "${PULSE_INCLUDE_RECOMMENDS:?PULSE_INCLUDE_RECOMMENDS must be set in config/pulse-build.conf}"
: "${PULSE_ISO_PUBLISHER:?PULSE_ISO_PUBLISHER must be set in config/pulse-build.conf}"
: "${PULSE_ISO_VOLUME:?PULSE_ISO_VOLUME must be set in config/pulse-build.conf}"
: "${PULSE_PACKAGE_PROFILE:=base}"

[[ $EUID -eq 0 ]] || fail "run with sudo on a clean Debian 13 build host."
command -v lb >/dev/null 2>&1 || fail "live-build is missing; install it with: apt install live-build"
command -v dpkg-query >/dev/null 2>&1 || fail "dpkg-query is unavailable."

if ! grep -qE '^VERSION_CODENAME=trixie$' /etc/os-release; then
  fail "the build host must be Debian 13 Trixie. Use a clean Debian 13 VM."
fi

[[ "$PULSE_DISTRO" == "trixie" ]] || fail "only PULSE_DISTRO=trixie is currently supported."
[[ "$PULSE_ARCH" == "amd64" ]] || fail "only PULSE_ARCH=amd64 is currently supported and tested by this build helper."
[[ "$PULSE_IMAGE_NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]] || fail "PULSE_IMAGE_NAME must contain lowercase letters, digits, and hyphens."
[[ "$PULSE_INSTALLER_MODE" =~ ^(live|none|cdrom|netinst|netboot|businesscard)$ ]] || fail "unsupported PULSE_INSTALLER_MODE."
[[ "$PULSE_INSTALLER_GUI" =~ ^(true|false)$ ]] || fail "PULSE_INSTALLER_GUI must be true or false."
[[ "$PULSE_INCLUDE_RECOMMENDS" =~ ^(true|false)$ ]] || fail "PULSE_INCLUDE_RECOMMENDS must be true or false."
[[ "$PULSE_PACKAGE_PROFILE" =~ ^(base|meteorology|developer)$ ]] || fail "PULSE_PACKAGE_PROFILE must be base, meteorology, or developer."

cd "$OS_DIR"
PROFILE_ACTIVE="$OS_DIR/config/package-lists/pulse-profile-selected.list.chroot"
cleanup() {
  rm -f -- "$PROFILE_ACTIVE"
}
[[ ! -e "$PROFILE_ACTIVE" ]] || fail "temporary profile manifest already exists: $PROFILE_ACTIVE; remove it after checking for an interrupted build."
trap cleanup EXIT

if [[ "$PULSE_PACKAGE_PROFILE" != "base" ]]; then
  PROFILE_SOURCE="$OS_DIR/config/package-lists/pulse-profile-$PULSE_PACKAGE_PROFILE.list.chroot.disabled"
  [[ -s "$PROFILE_SOURCE" ]] || fail "selected profile manifest is missing or empty: $PROFILE_SOURCE"
  cp -- "$PROFILE_SOURCE" "$PROFILE_ACTIVE"
fi

printf 'Building %s from Debian %s, architecture %s, package profile %s.\n' \
  "$PULSE_OS_NAME" "$PULSE_DISTRO" "$PULSE_ARCH" "$PULSE_PACKAGE_PROFILE"

lb config \
  --distribution "$PULSE_DISTRO" \
  --architectures "$PULSE_ARCH" \
  --binary-images iso-hybrid \
  --image-name "$PULSE_IMAGE_NAME" \
  --debian-installer "$PULSE_INSTALLER_MODE" \
  --debian-installer-gui "$PULSE_INSTALLER_GUI" \
  --debian-installer-preseedfile preseed.cfg \
  --archive-areas "main contrib non-free-firmware" \
  --apt-recommends "$PULSE_INCLUDE_RECOMMENDS" \
  --iso-application "$PULSE_OS_NAME" \
  --iso-publisher "$PULSE_ISO_PUBLISHER" \
  --iso-volume "$PULSE_ISO_VOLUME"

lb build

OUTPUT="$OS_DIR/$PULSE_IMAGE_NAME-$PULSE_ARCH.hybrid.iso"
if [[ ! -s "$OUTPUT" ]]; then
  fail "live-build finished without the expected ISO at $OUTPUT; inspect build logs and output files."
fi

sha256sum "$OUTPUT" > "$OUTPUT.sha256"
printf '\nBuild produced: %s\nChecksum: %s.sha256\n' "$OUTPUT" "$OUTPUT"
printf 'Reminder: verify BIOS/UEFI boot, live session, networking, and installer behavior before publishing this image.\n'
