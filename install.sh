#!/bin/bash

# KDE Unity Global Theme Installer
# Installs Ubuntu Unity look and feel for KDE Plasma

set -e

echo "Installing Ubuntu Unity theme for KDE Plasma..."

# Check if running as root for system-wide install
if [ "$EUID" -eq 0 ]; then
    THEME_DIR="/usr/share/plasma/look-and-feel/org.kde.unity.desktop"
    COLOR_DIR="/usr/share/color-schemes"
    AUTOSTART_DIR="/etc/xdg/autostart"
    BIN_DIR="/usr/local/bin"
    PLASMOID_DIR="/usr/share/plasma/plasmoids"
    SYSTEM_INSTALL=true
else
    THEME_DIR="$HOME/.local/share/plasma/look-and-feel/org.kde.unity.desktop"
    COLOR_DIR="$HOME/.local/share/color-schemes"
    AUTOSTART_DIR="$HOME/.config/autostart"
    BIN_DIR="$HOME/.local/bin"
    PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids"
    SYSTEM_INSTALL=false
fi

# Create directories
mkdir -p "$THEME_DIR/contents"
mkdir -p "$PLASMOID_DIR"
if [ "$SYSTEM_INSTALL" = true ]; then
    mkdir -p /usr/share/plasma/desktoptheme/Unity
    mkdir -p /usr/share/aurorae/themes/Unity
    PLASMA_THEME_DIR="/usr/share/plasma/desktoptheme/Unity"
    AURORAE_DIR="/usr/share/aurorae/themes/Unity"
    GTK_CONFIG_DIR="/usr/share/kde-unity-global-theme/gtk"
else
    mkdir -p "$HOME/.local/share/plasma/desktoptheme/Unity"
    mkdir -p "$HOME/.local/share/aurorae/themes/Unity" 
    PLASMA_THEME_DIR="$HOME/.local/share/plasma/desktoptheme/Unity"
    AURORAE_DIR="$HOME/.local/share/aurorae/themes/Unity"
    GTK_CONFIG_DIR="$HOME/.local/share/kde-unity-global-theme/gtk"
fi
mkdir -p "$COLOR_DIR"
mkdir -p "$AUTOSTART_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$(dirname "$GTK_CONFIG_DIR")"

# Copy look-and-feel theme files
echo "Installing Unity look-and-feel theme..."
cp -r contents/* "$THEME_DIR/contents/"
cp metadata.json "$THEME_DIR/"

# Copy Plasma desktop theme
echo "Installing Unity Plasma theme..."
cp -r plasma/desktoptheme/Unity/* "$PLASMA_THEME_DIR/"

# Copy window decoration theme
echo "Installing Unity window decorations..."
cp -r aurorae/Unity/* "$AURORAE_DIR/"

# Copy color scheme
echo "Installing Unity Dark color scheme..."
cp colors/UnityDark.colors "$COLOR_DIR/"

# Install Ubuntu wallpapers if available
echo "Setting up Ubuntu wallpapers..."
if [ "$SYSTEM_INSTALL" = true ]; then
    WALLPAPER_DIR="/usr/share/wallpapers/Ubuntu"
    mkdir -p "$WALLPAPER_DIR"
    # Copy wallpapers from system backgrounds if they exist
    if [ -d "/usr/share/backgrounds" ]; then
        find /usr/share/backgrounds -name "*ubuntu*" -o -name "*warty*" -exec cp {} "$WALLPAPER_DIR/" \; 2>/dev/null || true
    fi
else
    WALLPAPER_DIR="$HOME/.local/share/wallpapers/Ubuntu"
    mkdir -p "$WALLPAPER_DIR"
    # Copy wallpapers from system backgrounds if they exist
    if [ -d "/usr/share/backgrounds" ]; then
        find /usr/share/backgrounds -name "*ubuntu*" -o -name "*warty*" -exec cp {} "$WALLPAPER_DIR/" \; 2>/dev/null || true
    fi
fi

# Create wallpaper metadata
cat > "$WALLPAPER_DIR/metadata.desktop" <<EOF
[Desktop Entry]
Name=Ubuntu Wallpapers
X-KDE-PluginInfo-Name=Ubuntu
X-KDE-PluginInfo-Author=Ubuntu Team
X-KDE-PluginInfo-Email=
X-KDE-PluginInfo-License=GPL
EOF

# Copy GTK configuration
echo "Installing GTK theme configuration..."
mkdir -p "$GTK_CONFIG_DIR"
cp gtk/settings.ini "$GTK_CONFIG_DIR/"
cp gtk/gtk-4.0.ini "$GTK_CONFIG_DIR/"
cp gtk/gtkrc-2.0 "$GTK_CONFIG_DIR/"

# Install Unity Dash plasmoid
if [ -d "plasma/plasmoids/org.kde.unity.dash" ]; then
    echo "Installing Unity Dash plasmoid..."
    cp -r plasma/plasmoids/org.kde.unity.dash "$PLASMOID_DIR/"
fi

# Icon theme configuration is handled by the setup script
# Uses system Papirus icons instead of bundled themes

# Unity layout will be configured using KDE's native panels

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
echo "2. Select 'Unity'"
echo "3. Click 'Apply'"
echo ""
echo "Or the theme will be applied automatically on next login."