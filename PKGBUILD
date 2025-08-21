# Maintainer: Anonymo <meowdib@gmail.com>
pkgname=kde-unity-global-theme
pkgver=1.0
pkgrel=1
pkgdesc="Ubuntu Unity look and feel for KDE Plasma 6"
arch=('any')
url="https://github.com/Anonymo/kde-unity-global-theme"
license=('GPL3')
depends=(
    'plasma-desktop>=6.0' 
    'qt6-base>=6.4'
    'ttf-ubuntu-font-family'
    'yaru-icon-theme'
    'yaru-gtk-theme'
    'ubuntu-wallpapers'
    'plasma-browser-integration'
    'plasma-integration'
)
makedepends=('git')
source=("git+$url.git")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname"
    
    # Theme directory
    install -dm755 "$pkgdir/usr/share/plasma/look-and-feel/org.kde.unity.desktop"
    install -dm755 "$pkgdir/usr/share/plasma/desktoptheme/Unity"
    install -dm755 "$pkgdir/usr/share/aurorae/themes/Unity"
    
    # Install look-and-feel theme files
    cp -r contents "$pkgdir/usr/share/plasma/look-and-feel/org.kde.unity.desktop/"
    install -Dm644 metadata.json "$pkgdir/usr/share/plasma/look-and-feel/org.kde.unity.desktop/metadata.json"
    
    # Install Plasma desktop theme
    cp -r plasma/desktoptheme/Unity/* "$pkgdir/usr/share/plasma/desktoptheme/Unity/"
    
    # Install window decoration theme
    cp -r aurorae/Unity/* "$pkgdir/usr/share/aurorae/themes/Unity/"
    
    # Install color scheme
    install -Dm644 colors/UnityDark.colors "$pkgdir/usr/share/color-schemes/UnityDark.colors"
    
    # Unity layout configured through KDE native panels
    
    # Install GTK configuration
    install -dm755 "$pkgdir/usr/share/$pkgname/gtk"
    install -Dm644 gtk/settings.ini "$pkgdir/usr/share/$pkgname/gtk/settings.ini"
    install -Dm644 gtk/gtk-4.0.ini "$pkgdir/usr/share/$pkgname/gtk/gtk-4.0.ini"
    install -Dm644 gtk/gtkrc-2.0 "$pkgdir/usr/share/$pkgname/gtk/gtkrc-2.0"
    
    # Install setup script
    install -Dm755 scripts/setup-ubuntu-unity-theme.sh "$pkgdir/usr/bin/unity-theme-setup"
    
    # Install license
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    
    # Install documentation
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}

post_install() {
    echo ""
    echo "Unity theme for KDE Plasma 6 has been installed!"
    echo ""
    echo "To apply the theme:"
    echo "  1. Open System Settings → Appearance → Global Themes"
    echo "  2. Select 'Unity'"
    echo "  3. Click 'Apply'"
    echo ""
    echo "For automatic setup, run: unity-theme-setup"
    echo ""
    echo "All required packages have been installed automatically."
    echo ""
}

post_upgrade() {
    post_install
}

post_remove() {
    echo ""
    echo "Unity theme has been removed."
    echo "You may want to switch to another theme in System Settings."
    echo ""
}