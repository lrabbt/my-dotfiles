#!/bin/zsh
CONFIG_PATH=${XDG_CONFIG_HOME:-~/.config/tmux}
FILEPATH=${1:-$CONFIG_PATH/tmux.conf}
exec sed -i "s:~/.tmux.conf:$FILEPATH:g" $FILEPATH
