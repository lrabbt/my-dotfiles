# My Dotfiles #

## Objectives ##

Compact and move useful dotfiles between environments.

## Creating links ##

First of all, check the [configurations](#configurations) if it's the first installation on the system.

To create symbolic links for all dotfiles, you can use effuse, or do it by hand.

If effuse is chosen, just run:

```zsh
effuse
```

Check [this link](https://github.com/programble/effuse) for effuse reference.

## Configurations ##

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
