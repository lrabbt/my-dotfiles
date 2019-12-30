# My Dotfiles #

## Objectives ##

Compact and move useful dotfiles between environments.

## Getting started ##

### Requirements ###

* homebrew/linuxbrew
* vim (your favourite version)
* git
* zsh

### Installation ###

First of all, clone the project:

```sh
git clone https://github.com/lrabbt/my-dotfiles.git
```

There's a convenience script called `install.sh`, which ties the component's installation. Just run it and we're good to go :)

In case you want to install it manually, there is more information about the configuration in the section below. You can use effuse or create the symbolic links by yourself.

## Configurations ##

### Effuse ###

Check [this link](https://github.com/programble/effuse) for effuse reference.

### Zsh ###

Most linux distributions have zsh in their default repositories, for more information check their [official website](https://www.zsh.org/).

#### Oh My Zsh! ####

Oh My Zsh! is being used to manage Zsh plugins and themes. For installation instructions, check their [official website](https://ohmyz.sh/).

#### Powerline9K ####

For terminal theme, we'll be using [Powerline9K](https://github.com/Powerlevel9k/powerlevel9k).

### Tmux ###

Install tmux with your package manager, or check their [github page](https://github.com/tmux/tmux/wiki) for more recent versions.

### Oh My Tmux! ###

For basic tmux configuration, install [Oh My Tmux!](https://github.com/gpakosz/.tmux).

Depending on the theme being used, remember to have installed the [powerline font](https://github.com/powerline/fonts) on your terminal.

### Tpm ###

Used for tmux plugin management, check their [github page](https://github.com/tmux-plugins/tpm).

After installation, run `Prefix + I` to install all plugins configured on `.tmux.conf.local`.

## Vim ##

For Vim installation info, check their [official website](https://www.vim.org/).

Vim configuration is pretty straight foward, it's using [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins. Remember to run `:PlugInstall` the first time you run Vim to install plugins configured on `.vimrc`.

