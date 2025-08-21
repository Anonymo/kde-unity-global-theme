# Maintainer: Anonymo <meowdib@gmail.com>
pkgname=kde-unity-global-theme
pkgver=1.0
pkgrel=1
pkgdesc="Ubuntu Unity look and feel for KDE Plasma 6"
arch=('any')
url="https://github.com/Anonymo/kde-unity-global-theme"
license=('GPL3')
depends=('plasma-desktop>=6.0' 'qt6-base>=6.4')
optdepends=(
    'ttf-ubuntu-font-family: Ubuntu fonts for authentic Unity look'
    'yaru-icon-theme: Ubuntu Yaru icons'
    'yaru-gtk-theme: For GTK application theming'
    'latte-dock: For Unity-style dock'
    'plasma-browser-integration: For global menu in browsers'
)
makedepends=('git')
source=("git+$url.git")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname"
    
    # Theme directory
    install -dm755 "$pkgdir/usr/share/plasma/look-and-feel/Unity"
    
    # Install theme files
    cp -r contents "$pkgdir/usr/share/plasma/look-and-feel/Unity/"
    install -Dm644 metadata.desktop "$pkgdir/usr/share/plasma/look-and-feel/Unity/metadata.desktop"
    
    # Install color scheme
    install -Dm644 colors/UnityDark.colors "$pkgdir/usr/share/color-schemes/UnityDark.colors"
    
    # Install Latte layout
    install -Dm644 latte/Unity.layout.latte "$pkgdir/usr/share/latte/layouts/Unity.layout.latte"
    
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
    echo "Optional: Install recommended packages for best experience:"
    echo "  pacman -S ttf-ubuntu-font-family yaru-icon-theme yaru-gtk-theme"
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