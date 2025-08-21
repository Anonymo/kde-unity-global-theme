#!/bin/bash
# Apply Ubuntu Unity theme on first KDE login

if [ ! -f "$HOME/.ubuntu-unity-applied" ]; then
    # Apply Unity look and feel
    lookandfeeltool -a org.ubuntu.unity 2>/dev/null || true
    
    # Configure window decorations for Unity style
    kwriteconfig5 --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.kwin.aurorae"
    kwriteconfig5 --file kwinrc --group "org.kde.kdecoration2" --key "theme" "__aurorae__svg__Yaru"
    kwriteconfig5 --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnLeft" "XIA"
    kwriteconfig5 --file kwinrc --group "org.kde.kdecoration2" --key "ButtonsOnRight" ""
    
    # Configure icon theme
    kwriteconfig5 --file kdeglobals --group "Icons" --key "Theme" "Yaru"
    
    # Start Latte Dock with Unity layout
    if command -v latte-dock &>/dev/null; then
        kwriteconfig5 --file lattedockrc --group "UniversalSettings" --key "currentLayout" "Unity"
        killall latte-dock 2>/dev/null || true
        latte-dock &>/dev/null &
    fi
    
    # Set KRunner shortcut to Alt+Space (Unity HUD style)
    kwriteconfig5 --file kglobalshortcutsrc --group "org.kde.krunner.desktop" --key "_k_friendly_name" "KRunner"
    kwriteconfig5 --file kglobalshortcutsrc --group "org.kde.krunner.desktop" --key "_launch" "Alt+Space,Alt+F2,Search"
    
    # Restart KWin to apply window decoration changes
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
    
    # Mark theme as applied
    touch "$HOME/.ubuntu-unity-applied"
    
    # Remove autostart entry after first run
    rm -f "$HOME/.config/autostart/ubuntu-unity-theme.desktop" 2>/dev/null || true
    
    echo "Ubuntu Unity theme applied!"
fi