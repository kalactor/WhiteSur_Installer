# WhiteSur Installer

A one-click bash installer that applies the [WhiteSur](https://github.com/vinceliuice/WhiteSur-gtk-theme) macOS-inspired theme stack on GNOME Linux desktops.

## What It Does

This toolkit automates the installation of:

- **WhiteSur GTK Theme** (light, solid, rounded)
- **WhiteSur Icon Theme**
- **WhiteSur Cursor Theme**
- **WhiteSur Wallpapers** (auto-detects your screen resolution)
- **GNOME Extensions**: Blur My Shell, Dash to Dock, Logo Menu, Hide Activities, Just Perfection, Compiz Magic Lamp, Move Clock, and User Themes
- **Flatpak overrides** for consistent GTK theming in sandboxed apps

## Supported Distributions

| Distro Family | Package Manager |
|---------------|-----------------|
| Debian, Ubuntu, Linux Mint, Pop!_OS, Zorin OS | `apt` |
| Fedora, CentOS, RHEL | `dnf` |
| Arch Linux, Manjaro | `pacman` |
| Alpine Linux | `apk` |

## Prerequisites

- A GNOME-based desktop environment
- `sudo` privileges
- `git`, `curl`, and an active internet connection

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/WhiteSur_Installer.git
   cd WhiteSur_Installer
   ```

2. Run the installer:
   ```bash
   ./install.sh
   ```

3. Log out and log back in (or restart GNOME Shell with `Alt+F2`, type `r`, and press `Enter` on X11).

## Structure

| File | Purpose |
|------|---------|
| `install.sh` | Main entry point — detects OS, installs dependencies, and orchestrates everything |
| `whitesur.sh` | Clones and installs cursor, icon, GTK theme, prebuilt variants, and wallpapers |
| `ext-installer.sh` | Installs `gnome-extensions-cli` via `pipx` and deploys distro-specific GNOME extensions |
| `screen-res.sh` | Detects screen resolution (1080p / 2K / 4K) for the correct wallpaper size |
| `theme/` | Prebuilt `tar.xz` theme archives (Light/Dark, solid/standard) |

## Extension Sets

Extensions vary slightly by distribution to avoid conflicts with default DE features:

- **Default / Arch / Fedora**: All extensions including Dash to Dock
- **Ubuntu / Mint / Zorin**: Excludes Dash to Dock (Ubuntu ships its own dock)
- **Pop!_OS**: Excludes Dash to Dock and Hide Activities (uses Pop's COSMIC/launcher workflow)

## Uninstalling

To revert to the default GNOME appearance:

```bash
gsettings reset org.gnome.desktop.interface cursor-theme
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.gnome.desktop.background picture-uri
gsettings reset org.gnome.desktop.background picture-uri-dark
```

You can also disable extensions via **Extension Manager** (installed automatically) or `gnome-extensions-cli`.

## Notes

- The installer uses `set -e`, so it will stop on any error.
- Temporary clones are cleaned up automatically after installation.
- `fbset` is used for resolution detection when available; otherwise `xrandr` is used as a fallback.
- On Fedora, `fbset` is omitted from dependency installation as it may not be available.
- On Arch, `xrandr` is omitted since it is typically provided by `xorg-xrandr` which may already be present.

## License

This installer script collection is provided as-is for personal use. The actual WhiteSur themes and wallpapers are by [vinceliuice](https://github.com/vinceliuice).
