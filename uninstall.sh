#!/bin/bash

# KDE Unity Global Theme Uninstaller
# Removes Ubuntu Unity look and feel for KDE Plasma

set -e

echo "Uninstalling Ubuntu Unity theme for KDE Plasma..."

# Check if running as root for system-wide uninstall
if [ "$EUID" -eq 0 ]; then
    THEME_DIR="/usr/share/plasma/look-and-feel/org.kde.unity.desktop"
    COLOR_DIR="/usr/share/color-schemes"
    AUTOSTART_DIR="/etc/xdg/autostart"
    BIN_DIR="/usr/local/bin"
    PLASMOID_DIR="/usr/share/plasma/plasmoids"
    SYSTEM_UNINSTALL=true
    PLASMA_THEME_DIR="/usr/share/plasma/desktoptheme/Unity"
    AURORAE_DIR="/usr/share/aurorae/themes/Unity"
    GTK_CONFIG_DIR="/usr/share/kde-unity-global-theme/gtk"
    WALLPAPER_DIR="/usr/share/wallpapers/Ubuntu"
else
    THEME_DIR="$HOME/.local/share/plasma/look-and-feel/org.kde.unity.desktop"
    COLOR_DIR="$HOME/.local/share/color-schemes"
    AUTOSTART_DIR="$HOME/.config/autostart"
    BIN_DIR="$HOME/.local/bin"
    PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids"
    SYSTEM_UNINSTALL=false
    PLASMA_THEME_DIR="$HOME/.local/share/plasma/desktoptheme/Unity"
    AURORAE_DIR="$HOME/.local/share/aurorae/themes/Unity"
    GTK_CONFIG_DIR="$HOME/.local/share/kde-unity-global-theme/gtk"
    WALLPAPER_DIR="$HOME/.local/share/wallpapers/Ubuntu"
fi

# Remove theme directory
if [ -d "$THEME_DIR" ]; then
    echo "Removing theme files..."
    rm -rf "$THEME_DIR"
fi

# Remove Plasma desktop theme
if [ -d "$PLASMA_THEME_DIR" ]; then
    echo "Removing Plasma theme..."
    rm -rf "$PLASMA_THEME_DIR"
fi

# Remove window decoration theme
if [ -d "$AURORAE_DIR" ]; then
    echo "Removing window decorations..."
    rm -rf "$AURORAE_DIR"
fi

# Remove color scheme
if [ -f "$COLOR_DIR/UnityDark.colors" ]; then
    echo "Removing Unity Dark color scheme..."
    rm -f "$COLOR_DIR/UnityDark.colors"
fi

# Remove GTK configuration
if [ -d "$GTK_CONFIG_DIR" ]; then
    echo "Removing GTK theme configuration..."
    rm -rf "$GTK_CONFIG_DIR"
fi

# Remove Unity Dash plasmoid
if [ -d "$PLASMOID_DIR/org.kde.unity.dash" ]; then
    echo "Removing Unity Dash plasmoid..."
    rm -rf "$PLASMOID_DIR/org.kde.unity.dash"
fi

# Remove wallpapers
if [ -d "$WALLPAPER_DIR" ]; then
    echo "Removing wallpapers..."
    rm -rf "$WALLPAPER_DIR"
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