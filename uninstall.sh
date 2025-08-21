#!/bin/bash

# KDE Unity Global Theme Uninstaller
# Removes Ubuntu Unity look and feel for KDE Plasma

set -e

echo "Uninstalling Ubuntu Unity theme for KDE Plasma..."

# Check if running as root for system-wide uninstall
if [ "$EUID" -eq 0 ]; then
    THEME_DIR="/usr/share/plasma/look-and-feel/Unity"
    LATTE_DIR="/usr/share/latte/layouts"
    COLOR_DIR="/usr/share/color-schemes"
    AUTOSTART_DIR="/etc/xdg/autostart"
    BIN_DIR="/usr/local/bin"
    SYSTEM_UNINSTALL=true
else
    THEME_DIR="$HOME/.local/share/plasma/look-and-feel/Unity"
    LATTE_DIR="$HOME/.local/share/latte/layouts"
    COLOR_DIR="$HOME/.local/share/color-schemes"
    AUTOSTART_DIR="$HOME/.config/autostart"
    BIN_DIR="$HOME/.local/bin"
    SYSTEM_UNINSTALL=false
fi

# Remove theme directory
if [ -d "$THEME_DIR" ]; then
    echo "Removing theme files..."
    rm -rf "$THEME_DIR"
fi

# Remove color scheme
if [ -f "$COLOR_DIR/UnityDark.colors" ]; then
    echo "Removing Unity Dark color scheme..."
    rm -f "$COLOR_DIR/UnityDark.colors"
fi

# Remove Latte layout
if [ -f "$LATTE_DIR/Unity.layout.latte" ]; then
    echo "Removing Latte Unity layout..."
    rm -f "$LATTE_DIR/Unity.layout.latte"
fi

# Remove setup script
if [ -f "$BIN_DIR/setup-ubuntu-unity-theme.sh" ]; then
    rm -f "$BIN_DIR/setup-ubuntu-unity-theme.sh"
fi

# Remove autostart entry
if [ -f "$AUTOSTART_DIR/ubuntu-unity-theme.desktop" ]; then
    rm -f "$AUTOSTART_DIR/ubuntu-unity-theme.desktop"
fi

echo "Ubuntu Unity theme uninstalled successfully!"
echo ""
if [ "$SYSTEM_UNINSTALL" = true ]; then
    echo "Theme removed system-wide."
else
    echo "Theme removed for current user."
fi
echo ""
echo "Please select a different theme in System Settings → Appearance → Global Themes"