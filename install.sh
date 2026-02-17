#!/bin/bash
# install.sh

# Stop on errors
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config/omarchy-backup-$(date +%Y%m%d-%H%M%S)"

echo "🚀 Starting Omarchy Customizer (Ultrawide Edition)..."

# 1. Install System Packages
echo "⬇️ Installing System Packages..."
if command -v yay &> /dev/null; then
    yay -S --noconfirm --needed $(grep -vE "^\s*(#|$)" "$REPO_DIR/packages.txt" | tr '\n' ' ')
else
    echo "❌ 'yay' not found. Please install yay manually."
    exit 1
fi

# 2. Setup Mise & Rust
echo "🛠️ Setting up Rust via Mise..."

# Install Mise if not found
if ! command -v mise &> /dev/null; then
    echo "   Installing Mise..."
    curl https://mise.run | sh
    # Add to PATH for this session
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(~/.local/bin/mise activate bash)"
fi

# Install Rust via Mise
echo "   Installing Rust toolchain (latest)..."
mise use --global rust@latest

# 3. Compile Smart Waybar Tool
echo "🦀 Compiling Waybar Autohide Tool..."
cd "$REPO_DIR/scripts/waybar-autohide"
cargo build --release

# Install Binaries
mkdir -p "$HOME/.local/bin"
cp target/release/waybar-autohide "$HOME/.local/bin/"
cp "$REPO_DIR/scripts/toggle-waybar.sh" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/toggle-waybar.sh"

# Ensure PATH in shell config
if ! grep -q '.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# 4. Backup & Link Configs
echo "📦 Backing up & Linking configurations..."
mkdir -p "$BACKUP_DIR"

link_config() {
    local app=$1
    local source=$2
    local dest=$3

    # Backup if exists and is not already a symlink
    if [ -d "$(dirname "$dest")" ] && [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "   Backing up $dest"
        mv "$dest" "$BACKUP_DIR/$app-$(basename "$dest")"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$source" "$dest"
}

# Link theme (Tokyo-style: colors.toml generates most app configs; lives in ~/.config, never overwritten)
mkdir -p "$CONFIG_DIR/omarchy/themes"
link_config "theme" "$REPO_DIR/theme/matte-candy" "$CONFIG_DIR/omarchy/themes/matte-candy"

# Link Hyprland (structural overrides: blur, animations, keybindings)
link_config "hypr" "$REPO_DIR/configs/hypr/hyprland.conf" "$CONFIG_DIR/hypr/hyprland.conf"

# Link Waybar config only (modules, overlay; style comes from theme via Omarchy)
link_config "waybar" "$REPO_DIR/configs/waybar/config.jsonc" "$CONFIG_DIR/waybar/config.jsonc"

# Link Cursor IDE settings
link_config "cursor" "$REPO_DIR/configs/cursor" "$CONFIG_DIR/Cursor"

# 5. Set Defaults
echo "🌍 Setting Default Apps (Zen & Ghostty)..."

# Browser
export BROWSER=zen-browser
xdg-mime default zen-browser.desktop x-scheme-handler/http
xdg-mime default zen-browser.desktop x-scheme-handler/https
xdg-mime default zen-browser.desktop text/html

if ! grep -q "export BROWSER=zen-browser" "$HOME/.bashrc"; then
    echo 'export BROWSER=zen-browser' >> "$HOME/.bashrc"
fi

# Terminal
if [ -d "$CONFIG_DIR" ]; then
    echo "com.mitchellh.ghostty.desktop" > "$CONFIG_DIR/xdg-terminals.list"
fi

# 6. Reload
echo "🔄 Reloading Hyprland..."
hyprctl reload

echo "✅ Customization Complete! Please restart your session."
