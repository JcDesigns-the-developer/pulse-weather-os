#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OS_DIR="$ROOT/os"
OUTPUT="$OS_DIR/live-image-amd64.hybrid.iso"

fail() {
  printf 'Pulse Weather OS build error: %s\n' "$*" >&2
  exit 1
}

[[ $EUID -eq 0 ]] || fail "run with sudo on a clean Debian 13 build host."
command -v lb >/dev/null 2>&1 || fail "live-build is missing; install it with: apt install live-build"
command -v dpkg-query >/dev/null 2>&1 || fail "dpkg-query is unavailable."

if ! grep -qE '^VERSION_CODENAME=trixie$' /etc/os-release; then
  fail "the build host must be Debian 13 Trixie. Use a clean Debian 13 VM."
fi

cd "$OS_DIR"
lb config \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --debian-installer live \
  --archive-areas "main contrib non-free-firmware" \
  --apt-recommends true \
  --iso-application "Pulse Weather OS" \
  --iso-publisher "JcDesigns" \
  --iso-volume "PULSE_WEATHER_OS"

lb build

if [[ ! -s "$OUTPUT" ]]; then
  fail "live-build finished without the expected ISO at $OUTPUT; inspect build logs and output files."
fi

sha256sum "$OUTPUT" > "$OUTPUT.sha256"
printf '\nBuild produced: %s\nChecksum: %s.sha256\n' "$OUTPUT" "$OUTPUT"
printf 'Reminder: verify BIOS/UEFI boot and installation before publishing this image.\n'
