#!/bin/bash
# Apply Ubuntu Unity theme and configuration for KDE Plasma 6

set -e

echo "Applying Unity theme configuration..."

# Use kwriteconfig6 for Plasma 6
KWRITECONFIG="kwriteconfig6"

# Apply Unity look and feel
if command -v plasma-apply-lookandfeel &>/dev/null; then
    plasma-apply-lookandfeel -a org.kde.unity.desktop 2>/dev/null || true
else
    lookandfeeltool -a org.kde.unity.desktop 2>/dev/null || true
fi

# Configure fonts (Ubuntu family with Unity measurements)
$KWRITECONFIG --file kdeglobals --group "General" --key "font" "Ubuntu,11,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "General" --key "fixed" "Ubuntu Mono,13,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "General" --key "smallestReadableFont" "Ubuntu,9,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "General" --key "toolBarFont" "Ubuntu,10,-1,5,50,0,0,0,0,0"
$KWRITECONFIG --file kdeglobals --group "WM" --key "activeFont" "Ubuntu,11,-1,5,75,0,0,0,0,0"

# Configure color scheme
$KWRITECONFIG --file kdeglobals --group "General" --key "ColorScheme" "UnityDark"

# Configure window decorations for Unity style (close, minimize, maximize grouped on left)
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.breeze"
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "theme" "Breeze"
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnLeft" "XIA"
$KWRITECONFIG --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnRight" ""

# Enable borderless maximized windows (Unity style)
$KWRITECONFIG --file kwinrc --group "Windows" --key "BorderlessMaximizedWindows" "true"

# Disable wobbly windows effect (remove wiggling when moving windows)
$KWRITECONFIG --file kwinrc --group "Plugins" --key "wobblywindowsEnabled" "false"

# Configure icon theme - USE PAPIRUS for consistent visibility
$KWRITECONFIG --file kdeglobals --group "Icons" --key "Theme" "Papirus"
$KWRITECONFIG --file kdeglobals --group "Icons" --key "FallbackTheme" "breeze,Adwaita,hicolor" 

# Force refresh icon cache for working themes only
gtk-update-icon-cache -f -t /usr/share/icons/Papirus/ 2>/dev/null || true
gtk-update-icon-cache -f -t /usr/share/icons/Papirus-Light/ 2>/dev/null || true
gtk-update-icon-cache -f -t /usr/share/icons/breeze/ 2>/dev/null || true
gtk-update-icon-cache -f -t /usr/share/icons/Adwaita/ 2>/dev/null || true

# Configure cursor theme
$KWRITECONFIG --file kdeglobals --group "General" --key "cursorTheme" "Yaru"

# Configure plasma theme
$KWRITECONFIG --file plasmarc --group "Theme" --key "name" "Unity"

# Configure system tray to use proper icons with fallbacks
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "3" --group "Configuration" --group "General" --key "iconSpacing" "1"

# Icon configuration already done above - using Papirus only

# Fix missing application icons by ensuring proper icon cache refresh  
for icon_theme in /usr/share/icons/Papirus /usr/share/icons/Papirus-Light /usr/share/icons/breeze /usr/share/icons/Adwaita; do
    if [ -d "$icon_theme" ]; then
        gtk-update-icon-cache -f -t "$icon_theme" 2>/dev/null || true
    fi
done

# Configure Unity Launcher (vertical dock on left using native KDE panels)
echo "Setting up Unity Launcher..."

# Configure left panel as Unity-style launcher
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 2" --key "location" "3"
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 2" --key "thickness" "60"
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 2" --key "alignment" "132"
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 2" --key "floating" "0"
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 2" --key "panelVisibility" "2"

# Add Unity workspace switcher to left launcher panel
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "20" --key "plugin" "org.kde.plasma.pager"
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "20" --group "Configuration" --group "General" --key "displayedText" "Number"
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "20" --group "Configuration" --group "General" --key "showWindowIcons" "true"

echo "Unity Launcher configured with native KDE panels"

# Configure KDE panels for Unity-style layout
echo "Configuring Unity-style panel layout..."

# LOCK panels to screen edges like Ubuntu Unity - NEVER floating
# Iterate over all known panel IDs to ensure all panels are locked.
for i in 1 2 3 4 5 6 7 8 9 10 242 258; do
    $KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel $i" --key "floating" "0"
    $KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel $i" --key "panelVisibility" "0"
done

# Configure Unity Indicators system
echo "Setting up Unity Indicators..."

# Configure system tray to show Unity-style indicators
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "3" --group "Configuration" --group "General" --key "shownItems" "org.kde.plasma.networkmanagement,org.kde.plasma.audio,org.kde.plasma.battery,org.kde.plasma.notifications,org.kde.plasma.devicenotifier"

# Enable Unity-style indicators
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "3" --group "Configuration" --group "General" --key "extraItems" "org.kde.plasma.printmanager,org.kde.plasma.clipboard,org.kde.plasma.mediacontroller"

# Configure sound indicator
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "17" --group "Configuration" --group "General" --key "showVirtualDevices" "true"

# Configure network indicator  
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "2" --group "Applets" --group "18" --group "Configuration" --group "General" --key "showConnectionState" "true"

# Configure Unity-style session indicator (user menu)
$KWRITECONFIG --file kdeglobals --group "General" --key "showUserSwitcher" "true"

# Configure specific properties for the top panel (assuming it's Panel 1)
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 1" --key "thickness" "24"
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 1" --key "lengthMode" "1"
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 1" --key "maxLength" "100"
$KWRITECONFIG --file plasmashellrc --group "PlasmaViews" --group "Panel 1" --key "alignment" "132"

# Panel will use Unity-style layout defined in the theme

# Set KRunner shortcut to Alt+Space (Unity HUD style)
$KWRITECONFIG --file kglobalshortcutsrc --group "krunner" --key "_launch" "Alt+Space\tAlt+F2\tSearch,Alt+Space\tAlt+F2\tSearch,KRunner"

# Configure application launcher shortcut (Super key for Unity-style)
$KWRITECONFIG --file kglobalshortcutsrc --group "plasmashell" --key "activate application launcher" "Meta,Meta,Activate Application Launcher"
$KWRITECONFIG --file kglobalshortcutsrc --group "org.kde.plasma.emojier.desktop" --key "_launch" "none,none,Emoji Selector"

# Configure Unity-style HUD using KRunner and Rofi
echo "Setting up Unity-style HUD..."

# Set KRunner shortcut to Alt+Space (Unity HUD style) - force reload shortcuts
$KWRITECONFIG --file kglobalshortcutsrc --group "krunner" --key "_launch" "Alt+Space,Alt+Space,KRunner"

# Force reload of global shortcuts by restarting plasma shell
kquitapp6 plasmashell 2>/dev/null || true
sleep 1
plasmashell &>/dev/null &
sleep 2

# Configure Unity Dash system using KRunner
echo "Setting up Unity Dash with lenses/scopes..."

# Configure KRunner for Unity Dash-like behavior
$KWRITECONFIG --file krunnerrc --group "General" --key "ActivateWhenTypingOnDesktop" "true"
$KWRITECONFIG --file krunnerrc --group "General" --key "FreeFloating" "false"
$KWRITECONFIG --file krunnerrc --group "General" --key "RetainPriorSearch" "false"
$KWRITECONFIG --file krunnerrc --group "General" --key "ShowHistory" "false"

# Enable Unity Dash-style plugins (lenses/scopes equivalent)
echo "Enabling Unity Dash plugins..."

# Applications lens equivalent
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "servicesEnabled" "true"
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "appstreamEnabled" "true"

# Files & Folders lens equivalent  
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "placesEnabled" "true"
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "recentdocumentsEnabled" "true"
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "locationsEnabled" "true"

# Music/Media lens equivalent
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "audioplayercontrolEnabled" "true"

# System lens equivalent
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "systemsettingsEnabled" "true"
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "sessionsEnabled" "true"
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "powerdevilEnabled" "true"

# Calculator lens equivalent
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "calculatorEnabled" "true"

# Web search lens equivalent (like Unity's online scopes)
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "webshortcutsEnabled" "true"

# Activities lens equivalent
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "activitiesEnabled" "true"

# Configure search results display for Unity-style experience
$KWRITECONFIG --file krunnerrc --group "General" --key "textMode" "false"
$KWRITECONFIG --file krunnerrc --group "General" --key "historySize" "5"

# Set up Rofi as Unity HUD (Alt+Space like original Unity)
if command -v rofi >/dev/null 2>&1; then
    echo "Configuring Rofi as Unity HUD (Alt+Space)..."
    # Create HUD script
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/unity-hud <<'EOF'
#!/bin/bash
# Unity 7 style HUD - integrated into launcher area like original
rofi -show drun -theme-str 'window {width: 400px; height: 600px; location: west; anchor: west; x-offset: 72px; y-offset: 0;}' -theme-str 'listview {lines: 12; columns: 1;}' -theme-str 'inputbar {children: [prompt, textbox-prompt-colon, entry]; margin: 10px;}' -theme-str 'prompt {str: "Search...";}' -theme-str 'element {padding: 8px;}' -no-lazy-grab -matching fuzzy -theme Arc-Dark
EOF
    chmod +x ~/.local/bin/unity-hud
    
    # Set global shortcut for Unity HUD
    $KWRITECONFIG --file kglobalshortcutsrc --group "services" --key "unity-hud.desktop" "Alt+Space,none,Unity HUD"
    
    # Create desktop file for the shortcut
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/unity-hud.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Unity HUD
Exec=$HOME/.local/bin/unity-hud
NoDisplay=true
StartupNotify=false
EOF
    
    echo "Unity HUD configured: Press Alt+Space to access"
else
    echo "Using KRunner as Unity HUD (Alt+Space)"
fi

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

# Configure global menu (Unity-style) - disable local menu bars
$KWRITECONFIG --file kdeglobals --group "General" --key "menuBar" "Disabled"

# Enable global menu for Qt applications
$KWRITECONFIG --file kdeglobals --group "General" --key "DBusMenu" "true"

# Configure environment for global menu
echo 'export QT_QPA_PLATFORMTHEME=kde' >> ~/.profile
echo 'export GTK_MODULES=appmenu-gtk-module' >> ~/.profile

# Configure appmenu widget in the panel
$KWRITECONFIG --file plasma-org.kde.plasma.desktop-appletsrc --group "Containments" --group "1" --group "Applets" --group "2" --group "Configuration" --group "General" --key "showApplicationMenu" "true"

# Configure Unity Hot Corners
echo "Setting up Unity Hot Corners..."

# Top-left corner: Open Activities/Dash (like Unity's top-left reveal)
$KWRITECONFIG --file kwinrc --group "Effect-PresentWindows" --key "BorderActivateAll" "9"

# Top-right corner: Show desktop
$KWRITECONFIG --file kwinrc --group "Effect-ShowDesktop" --key "BorderActivate" "3"

# Bottom-left corner: Application launcher
$KWRITECONFIG --file kwinrc --group "Script-desktopchangeosd" --key "BorderActivate" "1"

# Bottom-right corner: Window spread
$KWRITECONFIG --file kwinrc --group "Effect-PresentWindows" --key "BorderActivate" "7"

# Enable hot corner effects
$KWRITECONFIG --file kwinrc --group "Plugins" --key "presentwindowsEnabled" "true"
$KWRITECONFIG --file kwinrc --group "Plugins" --key "showdesktopEnabled" "true"
$KWRITECONFIG --file kwinrc --group "Plugins" --key "desktopchangeosdEnabled" "true"

# Configure Unity Window Management
echo "Setting up Unity Window Management..."

# Configure edge barriers (Unity-style)
$KWRITECONFIG --file kwinrc --group "Windows" --key "ElectricBorderDelay" "150"
$KWRITECONFIG --file kwinrc --group "Windows" --key "ElectricBorderCooldown" "350"
$KWRITECONFIG --file kwinrc --group "Windows" --key "ElectricBorderPushbackPixels" "1"
$KWRITECONFIG --file kwinrc --group "Windows" --key "ElectricBorderMaximize" "true"
$KWRITECONFIG --file kwinrc --group "Windows" --key "ElectricBorderTiling" "true"

# Enable Unity-style window snapping
$KWRITECONFIG --file kwinrc --group "Windows" --key "WindowSnapZone" "10"
$KWRITECONFIG --file kwinrc --group "Windows" --key "CenterSnapZone" "0"
$KWRITECONFIG --file kwinrc --group "Windows" --key "SnapOnlyWhenOverlapping" "false"

# Configure workspace behavior like Unity
$KWRITECONFIG --file kwinrc --group "Desktops" --key "Number" "4"
$KWRITECONFIG --file kwinrc --group "Desktops" --key "Rows" "2"

# Enable Expo effect (Unity's workspace spread)
$KWRITECONFIG --file kwinrc --group "Plugins" --key "overviewEnabled" "true"
$KWRITECONFIG --file kwinrc --group "Effect-Overview" --key "BorderActivate" "9"

# Configure window switching (Alt+Tab) Unity-style
$KWRITECONFIG --file kwinrc --group "TabBox" --key "LayoutName" "big_icons"
$KWRITECONFIG --file kwinrc --group "TabBox" --key "HighlightWindows" "true"
$KWRITECONFIG --file kwinrc --group "TabBox" --key "ShowDesktop" "false"

# Configure window grouping behavior
$KWRITECONFIG --file kwinrc --group "Windows" --key "AutoRaise" "false"
$KWRITECONFIG --file kwinrc --group "Windows" --key "AutoRaiseInterval" "750"
$KWRITECONFIG --file kwinrc --group "Windows" --key "ClickRaise" "true"

# Configure Unity-style focus behavior
$KWRITECONFIG --file kwinrc --group "Windows" --key "FocusPolicy" "ClickToFocus"
$KWRITECONFIG --file kwinrc --group "Windows" --key "NextFocusPrefersMouse" "false"

# Enable Unity-style window effects
$KWRITECONFIG --file kwinrc --group "Plugins" --key "slideEnabled" "true"
$KWRITECONFIG --file kwinrc --group "Plugins" --key "fadeEnabled" "true"
$KWRITECONFIG --file kwinrc --group "Plugins" --key "minimizeanimationEnabled" "true"

# Configure KRunner for HUD-like functionality
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "appstreamEnabled" "true"
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "servicesEnabled" "true" 
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "placesEnabled" "true"
$KWRITECONFIG --file krunnerrc --group "Plugins" --key "recentdocumentsEnabled" "true"

# Restart Plasma Shell and KWin to apply changes
if command -v systemctl &>/dev/null && systemctl --user is-active plasma-plasmashell.service &>/dev/null; then
    systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
else
    kquitapp6 plasmashell 2>/dev/null || kquitapp5 plasmashell 2>/dev/null || true
    sleep 2
    plasmashell &>/dev/null &
fi

# FORCE icon theme back to Papirus after plasma restart (prevents any resets)
sleep 3
$KWRITECONFIG --file kdeglobals --group "Icons" --key "Theme" "Papirus"
echo "Icon theme locked to Papirus to prevent breaking"

# Restart KWin to apply window decoration changes
if command -v kwin_x11 &>/dev/null; then
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
elif command -v kwin_wayland &>/dev/null; then
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

echo "Unity theme configuration applied!"
echo "Please log out and back in for all changes to take effect."