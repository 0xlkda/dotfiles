#!/usr/bin/env bash

set -euo pipefail

# Update dotbot
git submodule sync --recursive

# Setup GPG & SSH
chown -R "$(whoami)" ~/.gnupg
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
chmod 700 ~/.ssh
chmod 644 ~/.ssh/config
