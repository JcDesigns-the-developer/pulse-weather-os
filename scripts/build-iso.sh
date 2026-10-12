#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OS_DIR="$ROOT/os"
OUTPUT="$ROOT/live-image-amd64.hybrid.iso"

fail() {
  printf 'Pulse Weather OS build error: %s\n' "$*" >&2
  exit 1
}

[[ $EUID -eq 0 ]] || fail "run with sudo on a clean Debian 13 build host."
command -v lb >/dev/null 2>&1 || fail "live-build is missing; install it with: apt install live-build"
command -v dpkg-query >/dev/null 2>&1 || fail "dpkg-query is unavailable."
command -v git >/dev/null 2>&1 || fail "git is required to inspect source provenance."

if ! grep -qE '^VERSION_CODENAME=trixie$' /etc/os-release; then
  fail "the build host must be Debian 13 Trixie. Use a clean Debian 13 VM/container."
fi

mkdir -p "$OS_DIR/config"
cd "$OS_DIR"

# Configure a hybrid amd64 image suitable for UEFI and legacy BIOS where
# supported by Debian live-build. Actual bootability still requires testing.
lb config \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --debian-installer live \
  --debian-installer-gui true \
  --archive-areas "main contrib non-free-firmware" \
  --apt-recommends true \
  --iso-application "Pulse Weather OS" \
  --iso-publisher "JcDesigns" \
  --iso-volume "PULSE_WEATHER_OS"

lb build

if [[ ! -s "$OUTPUT" ]]; then
  fail "live-build finished without the expected ISO at $OUTPUT; inspect live-build logs and output files."
fi

sha256sum "$OUTPUT" > "$OUTPUT.sha256"
printf '\nBuild produced: %s\nChecksum: %s.sha256\n' "$OUTPUT" "$OUTPUT"
printf 'Reminder: verify BIOS/UEFI boot and install behavior before publishing this image.\n'
