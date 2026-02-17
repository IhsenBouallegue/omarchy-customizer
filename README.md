# Omarchy Customizer

One-shot setup for [Omarchy](https://github.com/nickcoutsos/omarchy): Zen Browser, Ghostty, Hyprland keybindings, and a smart auto-hide Waybar. Uses a **custom theme** (Ayaka colors + Tokyo Night structure) that lives in `~/.config/omarchy/themes` — one place, never overwritten by Omarchy updates.

**Requires:** Omarchy (Hyprland), Arch-based system with `yay`.

---

## Install

```bash
git clone <this-repo> omarchy-customizer && cd omarchy-customizer
./install.sh
```

After install: open the Omarchy menu (`Super + Alt + Space`) → **Style > Theme** → select **matte-candy**. Restart your session when done.

Existing configs are backed up under `~/.config/omarchy-backup-<timestamp>`.

---

## How It Works

| Part | Location | Purpose |
|------|----------|---------|
| **Theme** | `~/.config/omarchy/themes/matte-candy` (symlinked) | Ayaka colors + styling. `colors.toml` drives Omarchy 3.3 generation for Ghostty, Waybar, btop, etc. You edit here; Omarchy never overwrites. |
| **Hyprland** | `~/.config/hypr/hyprland.conf` (symlinked) | Sources Omarchy default, adds Ayaka structural overrides (blur, animations, gaps, layer rules) + keybindings. |
| **Waybar** | `~/.config/waybar/config.jsonc` (symlinked) | Modules and overlay; style comes from the theme. |
| **Cursor** | `~/.config/Cursor` (symlinked) | IDE settings (theme, formatters, keybindings, etc.). |

---

## What Gets Installed

| Item | Description |
|------|--------------|
| **Packages** | `zen-browser-bin`, `ghostty`, `cursor-bin`, etc. (from `packages.txt`) |
| **Rust** | Via [Mise](https://mise.jdx.dev/); used to build the Waybar autohide tool |
| **Theme** | `matte-candy` in `~/.config/omarchy/themes` (colors.toml, btop.theme, neovim.lua, icons, vscode, backgrounds) |
| **Waybar** | Overlay bar; auto-hides at top edge; style from theme |
| **Configs** | Hyprland, Waybar, Cursor; symlinked from this repo |

---

## Layout

```
├── install.sh
├── packages.txt
├── theme/
│   └── matte-candy/           # Tokyo-style theme (symlinked to ~/.config/omarchy/themes)
│       ├── colors.toml        # Omarchy generates Ghostty, Waybar, btop, etc. from this
│       ├── btop.theme
│       ├── neovim.lua
│       ├── icons.theme
│       ├── vscode.json
│       ├── asusctl.rgb
│       └── backgrounds/       # Add wallpapers; or copy from omarchy-ayaka-theme
├── scripts/
│   ├── toggle-waybar.sh
│   └── waybar-autohide/
└── configs/
    ├── hypr/                  # hyprland.conf (structural + keybindings)
    ├── waybar/                # config.jsonc only
    └── cursor/                # Cursor IDE User settings
```

---

## Keybindings

| Key | Action |
|-----|--------|
| `Super + Enter` | Ghostty |
| `Super + B` | Zen Browser |
| `Super + M` | Toggle Waybar (manual override) |
| `Super + Q` | Close window |

---

## Manual Waybar Override

Run `~/.local/bin/toggle-waybar.sh` (or `Super + M`) to lock the bar hidden. Run again to re-enable auto-hide. Lock state: `/tmp/waybar-disabled`.
