#!/bin/zsh

 whence batman &> /dev/null && whence _man &> /dev/null && compdef _man batman
