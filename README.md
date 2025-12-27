# ARM64 Build of OutlineVPN's Shadowbox
A fork of [Minhyeok Park](https://github.com/pmh-only)'s [OutlineVPN](https://getoutline.org/) [Shadowbox image for ARM64](https://github.com/pmh-only/shadowbox-arm64-image). This version fixes interacting with Outline Manager by including the version in the image. Previously, the version would not be provided during the build stage, thus producing the version "dev" instead. The manager would be able to list the keys available, but not be able to fetch the keys, add any, adjust server settings, etc.

## Updates
This checks for a new version at the end of every week. If the updates are broken, it's likely I'll fix it but contact me anyway if it's been a while.

## Installation
You can use this script to install this build of Shadowbox.
```
# You can use a specific version (e.g. "1.12.3" instead of "latest" if you want)
export SB_IMAGE="ghcr.io/infinity6542/shadowbox:latest"

# Installation script, modified fron Jigsaw's real installation script
curl -sL "https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh" | sed '/local MACHINE_TYPE/,/fi/{d}' | bash
```
