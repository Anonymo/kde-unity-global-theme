# Unity Theme for KDE Plasma 6

Transform your KDE desktop to look like Ubuntu Unity - complete with the iconic orange colors, left-side window buttons, and Unity-style dock.

**⚠️ Requirements:** KDE Plasma 6 only (won't work on older versions)

## Easy Installation

### Arch Linux / CachyOS (Recommended)

1. **Install required packages:**
```bash
yay -S ttf-ubuntu-font-family yaru-icon-theme yaru-gtk-theme ubuntu-wallpapers plasma-browser-integration plasma-integration
```

   **Optional:** Install Latte Dock for Unity-style dock (may not work perfectly with Plasma 6):
   ```bash
   yay -S latte-dock
   ```

2. **Download and build the theme:**
```bash
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
./build-package.sh
```

3. **Install the package:**
```bash
sudo pacman -U kde-unity-global-theme-*.pkg.tar.zst
```

4. **Apply the theme:**
   - Open **System Settings** → **Appearance** → **Global Themes**
   - Select **Unity** and click **Apply**
   - Log out and back in

### For Other Distributions

<details>
<summary>Click here for manual installation</summary>

#### Fedora 41+
```bash
sudo dnf install git
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
./install.sh
```

#### Ubuntu 25.04+ / Debian Testing
```bash
sudo apt update && sudo apt install git
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
./install.sh
```

**After installation:**
1. Open **System Settings** → **Appearance** → **Global Themes**
2. Select **Unity** and click **Apply**
3. Log out and back in

</details>

## What You Get

- **Unity-style top panel** with global menu
- **Window buttons on the left** (like Ubuntu Unity)
- **Orange accent colors** throughout the system
- **Left-side dock** with Unity-style app indicators
- **Ubuntu fonts** for authentic look
- **Dark theme** with Unity colors

## Need Help?

### Common Issues

**Theme doesn't appear?**
```bash
systemctl --user restart plasma-plasmashell.service
```

**Want to reset everything?**
```bash
./uninstall.sh  # If you installed manually
# OR
sudo pacman -R kde-unity-global-theme  # If you used the package
```

**Need the Unity dock?**
- Install Latte Dock: `sudo pacman -S latte-dock` (Arch) or equivalent
- The Unity layout will be applied automatically

### Get Support
- [Report issues on GitHub](https://github.com/Anonymo/kde-unity-global-theme/issues)
- Make sure you're using KDE Plasma 6

---

**Credits:** Based on Ubuntu Unity design • GPL-3.0 License