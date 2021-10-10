if type thefuck > /dev/null; then
  export THEFUCK_REQUIRE_CONFIRMATION='false'

  eval $(thefuck --alias)
fi
