#!/usr/bin/env python3
"""
Unity Chameleon Panel Colors
Extracts dominant colors from wallpaper and applies them to KDE panels
"""

import os
import sys
import subprocess
import colorsys
from PIL import Image
import json

def get_current_wallpaper():
    """Get the current wallpaper path from KDE"""
    try:
        result = subprocess.run([
            'kreadconfig6', '--file', 'plasma-org.kde.plasma.desktop-appletsrc',
            '--group', 'Wallpaper', '--key', 'Image'
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            return result.stdout.strip()
        
        # Fallback: check plasmashell config
        result = subprocess.run([
            'kreadconfig6', '--file', 'plasmarc',
            '--group', 'Wallpapers', '--key', 'usersWallpapers'
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            wallpapers = result.stdout.strip().split(',')
            if wallpapers:
                return wallpapers[0]
                
    except Exception as e:
        print(f"Error getting wallpaper: {e}")
    
    # Default wallpaper location
    return os.path.expanduser("~/.local/share/wallpapers/default.jpg")

def extract_dominant_color(image_path, num_colors=5):
    """Extract dominant colors from an image"""
    try:
        if not os.path.exists(image_path):
            print(f"Wallpaper not found: {image_path}")
            return "#E95420"  # Ubuntu orange fallback
            
        # Open and resize image for performance
        with Image.open(image_path) as img:
            img = img.convert('RGB')
            img = img.resize((150, 150))  # Reduce size for speed
            
            # Get all pixels
            pixels = list(img.getdata())
            
            # Create color frequency map
            color_freq = {}
            for pixel in pixels:
                # Skip very dark or very light pixels
                brightness = sum(pixel) / 3
                if brightness < 30 or brightness > 225:
                    continue
                    
                # Group similar colors (reduce precision)
                color = tuple(c // 8 * 8 for c in pixel)
                color_freq[color] = color_freq.get(color, 0) + 1
            
            if not color_freq:
                return "#E95420"
            
            # Sort by frequency and get most common
            sorted_colors = sorted(color_freq.items(), key=lambda x: x[1], reverse=True)
            dominant_color = sorted_colors[0][0]
            
            # Convert to hex
            hex_color = '#%02x%02x%02x' % dominant_color
            
            # Adjust for better panel visibility
            return adjust_color_for_panel(hex_color)
            
    except Exception as e:
        print(f"Error extracting color from {image_path}: {e}")
        return "#E95420"

def adjust_color_for_panel(hex_color):
    """Adjust color to be suitable for panel background"""
    # Convert hex to RGB
    r = int(hex_color[1:3], 16) / 255.0
    g = int(hex_color[3:5], 16) / 255.0
    b = int(hex_color[5:7], 16) / 255.0
    
    # Convert to HSV for easier manipulation
    h, s, v = colorsys.rgb_to_hsv(r, g, b)
    
    # Adjust saturation and value for better panel appearance
    s = min(0.7, max(0.3, s))  # Keep saturation reasonable
    v = min(0.4, max(0.15, v))  # Keep it dark enough for text visibility
    
    # Convert back to RGB
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    
    # Convert to hex
    return '#%02x%02x%02x' % (int(r * 255), int(g * 255), int(b * 255))

def apply_panel_colors(color):
    """Apply the extracted color to KDE panels"""
    try:
        # Create custom plasma theme colors
        theme_dir = os.path.expanduser("~/.local/share/plasma/desktoptheme/Unity-Chameleon")
        os.makedirs(theme_dir, exist_ok=True)
        
        # Create colors file
        colors_content = f"""[Colors:Window]
BackgroundNormal={color}
BackgroundAlternate={color}

[Colors:Button] 
BackgroundNormal={color}
BackgroundAlternate={color}

[Colors:View]
BackgroundNormal={color}
BackgroundAlternate={color}
"""
        
        with open(os.path.join(theme_dir, "colors"), 'w') as f:
            f.write(colors_content)
        
        # Create metadata
        metadata_content = f"""[Desktop Entry]
Name=Unity Chameleon
Comment=Unity theme with adaptive panel colors
X-KDE-PluginInfo-Name=Unity-Chameleon
X-KDE-PluginInfo-Version=1.0
X-KDE-PluginInfo-Category=Plasma Theme
"""
        
        with open(os.path.join(theme_dir, "metadata.desktop"), 'w') as f:
            f.write(metadata_content)
        
        print(f"Applied chameleon color: {color}")
        return True
        
    except Exception as e:
        print(f"Error applying panel colors: {e}")
        return False

def setup_wallpaper_monitor():
    """Set up monitoring for wallpaper changes"""
    monitor_script = f"""#!/bin/bash
# Unity Chameleon Wallpaper Monitor
while inotifywait -e modify ~/.config/plasma-org.kde.plasma.desktop-appletsrc 2>/dev/null; do
    sleep 2
    python3 {__file__}
done
"""
    
    monitor_path = os.path.expanduser("~/.local/bin/unity-chameleon-monitor.sh")
    os.makedirs(os.path.dirname(monitor_path), exist_ok=True)
    
    with open(monitor_path, 'w') as f:
        f.write(monitor_script)
    
    os.chmod(monitor_path, 0o755)
    
    # Create systemd user service
    service_content = f"""[Unit]
Description=Unity Chameleon Panel Colors
After=graphical-session.target

[Service]
Type=simple
ExecStart={monitor_path}
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
"""
    
    service_dir = os.path.expanduser("~/.config/systemd/user")
    os.makedirs(service_dir, exist_ok=True)
    
    with open(os.path.join(service_dir, "unity-chameleon.service"), 'w') as f:
        f.write(service_content)

def main():
    """Main function"""
    if len(sys.argv) > 1 and sys.argv[1] == "--setup-monitor":
        setup_wallpaper_monitor()
        print("Chameleon monitor service set up")
        return
    
    # Get current wallpaper
    wallpaper_path = get_current_wallpaper()
    print(f"Current wallpaper: {wallpaper_path}")
    
    # Extract dominant color
    color = extract_dominant_color(wallpaper_path)
    print(f"Dominant color: {color}")
    
    # Apply to panels
    if apply_panel_colors(color):
        # Refresh plasma theme
        try:
            subprocess.run(['kbuildsycoca6'], check=False)
            print("Panel colors updated successfully!")
        except Exception as e:
            print(f"Warning: Could not refresh theme cache: {e}")
    else:
        print("Failed to apply panel colors")

if __name__ == "__main__":
    main()