#!/bin/bash
# Apply Ubuntu Unity theme and configuration for KDE Plasma 6

set -e

echo "Applying Unity theme configuration..."

# Use kwriteconfig6 for Plasma 6
KWRITECONFIG="kwriteconfig6"

# Apply Unity look and feel
if command -v plasma-apply-lookandfeel &>/dev/null; then
    plasma-apply-lookandfeel -a Unity 2>/dev/null || true
else
    lookandfeeltool -a Unity 2>/dev/null || true
fi

# Configure fonts (Ubuntu family with Unity measurements)
$KWRITECONFIG --file kdeglobals --group "General" --key "font" "Ubuntu,11,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "General" --key "fixed" "Ubuntu Mono,13,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "General" --key "smallestReadableFont" "Ubuntu,9,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "General" --key "toolBarFont" "Ubuntu,10,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "WM" --key "activeFont" "Ubuntu,11,-1,5,75,0,0,0,0,0"

# Configure color scheme
$KWRITECONFIG --file kdeglobals --group "General" --key "ColorScheme" "UnityDark"

# Configure window decorations for Unity style (buttons on left)
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.breeze"
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "theme" "Breeze"
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnLeft" "XSM"
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnRight" "IA"

# Enable borderless maximized windows (Unity style)
$KWRITECONFIG --file kwinrc --group "Windows" --key "BorderlessMaximizedWindows" "true"

# Configure icon theme
$KWRITECONFIG --file kdeglobals --group "Icons" --key "Theme" "Yaru-dark"

# Configure cursor theme
$KWRITECONFIG --file kdeglobals --group "General" --key "cursorTheme" "Yaru"

# Configure plasma theme
$KWRITECONFIG --file plasmarc --group "Theme" --key "name" "Unity"

# Configure panel height (24px Unity style)
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel" --group "Defaults" --key "thickness" "24"

# Configure Latte Dock with Unity layout
if command -v latte-dock &>/dev/null; then
    $KWRITECONFIG --file lattedockrc --group "UniversalSettings" --key "currentLayout" "Unity"
    $KWRITECONFIG --file lattedockrc --group "PlasmaThemeExtended" --key "backgroundOpacity" "64"
    
    # Start Latte Dock
    killall latte-dock 2>/dev/null || true
    sleep 1
    latte-dock &>/dev/null &
fi

# Set KRunner shortcut to Alt+Space (Unity HUD style)
$KWRITECONFIG --file kglobalshortcutsrc --group "krunner" --key "_launch" "Alt+Space\tAlt+F2\tSearch,Alt+Space\tAlt+F2\tSearch,KRunner"

# Configure application launcher shortcut (Super key)
$KWRITECONFIG --file kglobalshortcutsrc --group "plasmashell" --key "activate application launcher" "Meta\tAlt+F1,Meta\tAlt+F1,Activate Application Launcher"

# GTK theme configuration
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

# Copy GTK configuration files
if [ -f "/usr/share/kde-unity-global-theme/gtk/settings.ini" ]; then
    cp "/usr/share/kde-unity-global-theme/gtk/settings.ini" "$HOME/.config/gtk-3.0/"
    cp "/usr/share/kde-unity-global-theme/gtk/gtk-4.0.ini" "$HOME/.config/gtk-4.0/settings.ini"
    cp "/usr/share/kde-unity-global-theme/gtk/gtkrc-2.0" "$HOME/.gtkrc-2.0"
elif [ -f "$HOME/.local/share/kde-unity-global-theme/gtk/settings.ini" ]; then
    cp "$HOME/.local/share/kde-unity-global-theme/gtk/settings.ini" "$HOME/.config/gtk-3.0/"
    cp "$HOME/.local/share/kde-unity-global-theme/gtk/gtk-4.0.ini" "$HOME/.config/gtk-4.0/settings.ini"
    cp "$HOME/.local/share/kde-unity-global-theme/gtk/gtkrc-2.0" "$HOME/.gtkrc-2.0"
fi

# Configure KDE to use GTK theme
$KWRITECONFIG --file kdeglobals --group "KDE" --key "widgetStyle" "Breeze"

# Enable global menu for supported applications
$KWRITECONFIG --file kdeglobals --group "General" --key "menuBar" "Disabled"

# Restart Plasma Shell and KWin to apply changes
if command -v systemctl &>/dev/null && systemctl --user is-active plasma-plasmashell.service &>/dev/null; then
    systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
else
    kquitapp6 plasmashell 2>/dev/null || kquitapp5 plasmashell 2>/dev/null || true
    sleep 2
    plasmashell &>/dev/null &
fi

# Restart KWin to apply window decoration changes
if command -v kwin_x11 &>/dev/null; then
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
elif command -v kwin_wayland &>/dev/null; then
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

echo "Unity theme configuration applied!"
echo "Please log out and back in for all changes to take effect."