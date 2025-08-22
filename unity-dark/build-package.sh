#!/bin/bash

# Build script for creating Arch package

set -e

echo "Building KDE Unity Global Theme package..."

# Clean previous builds
if [ -d pkg ]; then
    rm -rf pkg
fi

if [ -d src ]; then
    rm -rf src
fi

# Remove old packages
rm -f kde-unity-global-theme-*.pkg.tar.zst

# Build the package
makepkg -sf

echo ""
echo "Package built successfully!"
echo ""
echo "To install the package, run:"
echo "  sudo pacman -U kde-unity-global-theme-*.pkg.tar.zst"
echo ""
echo "Or for AUR helpers:"
echo "  yay -U kde-unity-global-theme-*.pkg.tar.zst"
echo ""