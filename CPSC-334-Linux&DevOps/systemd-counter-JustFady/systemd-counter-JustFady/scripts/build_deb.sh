#!/bin/bash
set -e

# Define package directory
PACKAGE_NAME="counter"
BUILD_DIR="deb_build"
DEB_PACKAGE="${PACKAGE_NAME}-v2.0.0.deb"

# Ensure clean build
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/DEBIAN
mkdir -p $BUILD_DIR/usr/local/bin
mkdir -p $BUILD_DIR/Library/LaunchDaemons

# Copy the main script to the appropriate directory
cp counter.py $BUILD_DIR/usr/local/bin/counter

# Copy control files
cp scripts/postinst $BUILD_DIR/DEBIAN/postinst
cp scripts/prerm $BUILD_DIR/DEBIAN/prerm
chmod 755 $BUILD_DIR/DEBIAN/postinst
chmod 755 $BUILD_DIR/DEBIAN/prerm

# Create macOS launchd plist file
cat <<EOL > $BUILD_DIR/Library/LaunchDaemons/counter.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>counter</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/counter</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/var/log/counter.error.log</string>
    <key>StandardOutPath</key>
    <string>/var/log/counter.log</string>
    <key>UserName</key>
    <string>counter</string>
</dict>
</plist>
EOL

# Create control file
cat <<EOL > $BUILD_DIR/DEBIAN/control
Package: $PACKAGE_NAME
Version: 2.0.0
Section: base
Priority: optional
Architecture: all
Maintainer: Fady Youssef <your.email@example.com>
Description: Simple counter service with support for both systemd and launchd
 This package provides a counter service that works on both Linux (using systemd)
 and macOS (using launchd).
EOL

# Set permissions
chmod 755 $BUILD_DIR/usr/local/bin/counter
chmod 644 $BUILD_DIR/Library/LaunchDaemons/counter.plist

# Build the Debian package
dpkg-deb --build $BUILD_DIR $DEB_PACKAGE
echo "Debian package built: $DEB_PACKAGE"