#!/bin/zsh

if type -p bw > /dev/null; then
  eval "$(bw completion --shell zsh); compdef _bw bw;"
else
  echo "BitWarden not installed!"
fi
