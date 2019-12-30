#!/bin/bash

# Requirements: homebrew, vim, git, zsh

WORKING_DIR=$(dirname $(readlink -f "install.sh"))

git submodule update --init --recursive

brew install gcc cmake ruby python go npm tmux xclip fasd fzf thefuck ripgrep
gem install effuse

# Oh-My-Zsh!
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Powerline fonts
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

# Create symbolic links
effuse

# Install vim plugins
vim +PlugInstall +qall

# Install YouCompleteMe (Vim)
cd ~/.vim/plugged/youcompleteme
python3 install.py --all --clangd-completer
cd $WORKING_DIR

# Install tmux plugins
tmux -c 'sh -c "~/.tmux/plugins/tpm/bindings/install_plugins && exit"'

