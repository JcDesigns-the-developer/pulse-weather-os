# Pulse desktop identity

Pulse Weather OS uses LXQt as its desktop environment, configured as a restrained, practical meteorology workstation. The Pulse-specific presentation lives in this repository's overlays rather than a fork of every upstream desktop component.

## Included branding

- Original Pulse Weather OS SVG wallpaper at `/usr/share/backgrounds/pulse/pulse-default.svg`.
- LXQt session defaults under `/etc/xdg/lxqt/lxqt.conf`.
- A Pulse Weather Center launcher and local welcome page.
- The welcome page clearly labels this as a development build and explains the live/archived/model/experimental data distinction.

## Important boundaries

LXQt, Qt, Debian, SDDM, and other included software remain upstream projects and retain their own names, copyrights, and licenses. Pulse owns its original branding, configuration, artwork, and applications; it does not claim ownership of upstream code or remove required license notices. This keeps the OS recognizable as Pulse without creating an unsafe or legally misleading wholesale rebrand of third-party software.

The build still needs an actual ISO build and live-session test. Confirm the selected LXQt theme and icon theme exist in the final package set; adjust them if the target Debian packages differ. The custom wallpaper is currently supplied as an asset, and applying it automatically as the PCManFM-Qt desktop background must be verified in a booted image.
