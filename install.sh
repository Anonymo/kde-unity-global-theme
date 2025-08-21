#!/bin/bash

# KDE Unity Global Theme Installer
# Installs Ubuntu Unity look and feel for KDE Plasma

set -e

echo "Installing Ubuntu Unity theme for KDE Plasma..."

# Check if running as root for system-wide install
if [ "$EUID" -eq 0 ]; then
    THEME_DIR="/usr/share/plasma/look-and-feel/org.ubuntu.unity"
    LATTE_DIR="/usr/share/latte-dock/layouts/Unity"
    AUTOSTART_DIR="/etc/xdg/autostart"
    BIN_DIR="/usr/local/bin"
    SYSTEM_INSTALL=true
else
    THEME_DIR="$HOME/.local/share/plasma/look-and-feel/org.ubuntu.unity"
    LATTE_DIR="$HOME/.local/share/latte-dock/layouts/Unity"
    AUTOSTART_DIR="$HOME/.config/autostart"
    BIN_DIR="$HOME/.local/bin"
    SYSTEM_INSTALL=false
fi

# Create directories
mkdir -p "$THEME_DIR/contents"
mkdir -p "$LATTE_DIR"
mkdir -p "$AUTOSTART_DIR"
mkdir -p "$BIN_DIR"

# Copy theme files
echo "Copying theme files..."
cp -r contents/* "$THEME_DIR/contents/"
cp metadata.desktop "$THEME_DIR/"

# Install Latte Dock layout if Latte is installed
if command -v latte-dock &>/dev/null; then
    echo "Installing Latte Dock Unity layout..."
    cp latte/Unity.layout.latte "$LATTE_DIR/"
fi

# Install first-run setup script
cp scripts/setup-ubuntu-unity-theme.sh "$BIN_DIR/"
chmod +x "$BIN_DIR/setup-ubuntu-unity-theme.sh"

# Create autostart entry
cat > "$AUTOSTART_DIR/ubuntu-unity-theme.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Ubuntu Unity Theme Setup
Exec=$BIN_DIR/setup-ubuntu-unity-theme.sh
Hidden=false
NoDisplay=false
X-KDE-autostart-after=panel
X-KDE-StartupNotify=false
OnlyShowIn=KDE;
EOF

echo "Ubuntu Unity theme installed successfully!"
echo ""
if [ "$SYSTEM_INSTALL" = true ]; then
    echo "Theme installed system-wide."
else
    echo "Theme installed for current user."
fi
echo ""
echo "To apply the theme:"
echo "1. Open System Settings → Appearance → Global Themes"
echo "2. Select 'Ubuntu Unity'"
echo "3. Click 'Apply'"
echo ""
echo "Or the theme will be applied automatically on next login."