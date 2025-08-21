# KDE Unity Global Theme

A KDE Plasma global theme inspired by Ubuntu Unity's visual design

## Overview

This theme brings the distinctive Ubuntu Unity look and feel to KDE Plasma desktop environments, providing a seamless visual experience for users who appreciate Unity's clean and modern aesthetic.

<details>
<summary><b>✨ Features</b></summary>

- Unity-inspired window decorations
- Ubuntu color schemes (Ambiance/Radiance)
- Panel styling matching Unity's top bar
- Consistent theming across Plasma 6 components
- Support for both light and dark variants

</details>

## Installation

<details>
<summary><b>🔧 Installation Instructions</b></summary>

### Arch Linux / CachyOS
```bash
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
./install.sh
```

### Fedora 41+
```bash
sudo dnf install git
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
./install.sh
```

### Ubuntu 25.04+
```bash
sudo apt update
sudo apt install git
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
./install.sh
```

### Debian Testing/Sid
```bash
sudo apt update
sudo apt install git
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
./install.sh
```

</details>

<details>
<summary><b>📋 Requirements</b></summary>

- KDE Plasma 6.0 or later
- Qt 6.4 or later
- Git
- Bash shell

</details>

## Components

<details>
<summary><b>🎨 Included Components</b></summary>

### Core Theme Components
- **Look-and-Feel Theme**: Complete Unity visual package for Plasma 6
- **Plasma Desktop Theme**: Unity-styled panels with dark gradient background
- **Color Scheme**: Unity Dark with Ubuntu orange (#e66100) accent colors
- **Window Decorations**: Unity-style titlebar with buttons on the left (close, minimize, maximize)

### Layout & Configuration  
- **Latte Dock Layout**: Left-side Unity dock with 42px icons and 64% transparency
- **Panel Configuration**: 24px height top panel (Unity standard)
- **Font Configuration**: Ubuntu font family (11pt general, 13pt monospace)

### Integration
- **GTK Theme Integration**: Yaru-dark theme for GTK applications
- **Keyboard Shortcuts**: Alt+Space for search (HUD-style), Super key for launcher
- **Global Menu**: Application menu integration in top panel
- **Setup Script**: Automatic configuration tool (`unity-theme-setup`)

</details>

## Configuration

<details>
<summary><b>⚙️ Initial Setup</b></summary>

After installation, apply the theme through:
1. System Settings → Appearance → Global Themes
2. Select "Unity" from the available themes
3. Click "Apply"

For best results:
- Log out and back in after applying
- Restart Plasma shell if needed: `plasmashell --replace &`

</details>

<details>
<summary><b>🎯 Customization Options</b></summary>

You can mix and match components:
- System Settings → Appearance → Plasma Style
- System Settings → Colors & Themes → Colors
- System Settings → Window Decorations
- System Settings → Icons
- System Settings → Cursors

### Advanced Customization
- Edit `~/.local/share/plasma/look-and-feel/Unity/contents/defaults` for default settings
- Modify color schemes in `~/.local/share/color-schemes/`
- Adjust panel configuration in `~/.config/plasma-org.kde.plasma.desktop-appletsrc`

</details>


## Compatibility

<details>
<summary><b>✅ Compatible Distributions</b></summary>

### KDE Plasma 6 Distributions
- Ubuntu 25.04+ (upcoming)
- Fedora 41+ KDE Spin
- Arch Linux (latest)
- CachyOS
- EndeavourOS KDE
- Manjaro KDE (unstable/testing)
- openSUSE Tumbleweed
- Debian Testing/Sid
- KDE Neon Testing/Unstable

**Note:** This theme requires KDE Plasma 6 and will NOT work on older Plasma 5 distributions.

</details>

## Troubleshooting

<details>
<summary><b>🔍 Common Issues</b></summary>

### Theme not appearing after installation
- Ensure all files have correct permissions: `chmod -R 755 ~/.local/share/plasma/`
- Restart KDE: `systemctl --user restart plasma-plasmashell.service`

### Panel not looking correct
- Reset panel to defaults first, then reapply theme
- Check if Latte Dock is conflicting with native panel

### Colors not applying properly
- Clear cache: `rm -rf ~/.cache/plasma*`
- Reapply color scheme manually in System Settings

</details>

## Contributing

<details>
<summary><b>🤝 How to Contribute</b></summary>

Contributions are welcome! Here's how you can help:

1. **Report Bugs**: [Open an issue](https://github.com/Anonymo/kde-unity-global-theme/issues) with details
2. **Suggest Features**: Share your ideas in the issues section
3. **Submit Pull Requests**: 
   - Fork the repository
   - Create a feature branch
   - Make your changes
   - Submit a PR with clear description

### Development Setup
```bash
git clone https://github.com/Anonymo/kde-unity-global-theme.git
cd kde-unity-global-theme
# Make your changes
./install.sh  # Install the theme
```

</details>

## License

<details>
<summary><b>📄 License Information</b></summary>

GPL-3.0 License - See [LICENSE](LICENSE) file for details

This theme is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

</details>

## Credits & Support

<details>
<summary><b>👥 Credits</b></summary>

- Inspired by Ubuntu Unity desktop environment
- Based on Ubuntu's Ambiance and Radiance themes
- Uses elements from Yaru icon theme
- Community contributors and testers

</details>

<details>
<summary><b>💬 Support</b></summary>

For issues, questions, or suggestions:
- [Open an issue](https://github.com/Anonymo/kde-unity-global-theme/issues) on GitHub
- Check existing issues for solutions
- Join the discussion in the issues section

</details>