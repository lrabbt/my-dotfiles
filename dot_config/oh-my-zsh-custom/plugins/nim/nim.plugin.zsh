if [[ -d ~/.nimble/bin ]]; then
  typeset -U path
  path=(~/.nimble/bin $path)
fi
