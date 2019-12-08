#!/bin/sh

if ! command -v effuse > /dev/null 2>&1 ; then
    echo "Error! Effuse not installed, please check README.md for more information."
    exit 1
elif ! command -v curl > /dev/null 2>&1 ; then
    echo "Error! Curl not found, please install it."
    exit 1
fi

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Create simlinks
effuse -y

echo "Environment installed!"

