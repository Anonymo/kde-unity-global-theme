#!/bin/bash
# Apply Unity theme without system-wide changes
# This script only applies the Unity look and feel without modifying system settings

set -e

echo "Applying Unity theme (minimal, theme-only)..."

# Apply Unity look and feel using standard KDE theme mechanism
if command -v plasma-apply-lookandfeel &>/dev/null; then
    plasma-apply-lookandfeel -a org.kde.unity.desktop 2>/dev/null || true
else
    lookandfeeltool -a org.kde.unity.desktop 2>/dev/null || true
fi

echo "Unity theme applied!"
echo "Note: This minimal version only applies the theme without changing system settings."
echo "Window buttons, virtual desktops, and shortcuts remain unchanged."