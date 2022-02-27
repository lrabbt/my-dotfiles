#!/bin/zsh

bwu() {
  BW_SESSION=$(bw unlock --raw)
  export BW_SESSION
}
