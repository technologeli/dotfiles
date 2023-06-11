#!/usr/bin/env bash

pushd ~/dotfiles

stow -R aliases/ eww/ fish/ hypr/ kitty/ nvim/ starship/ tmux/ wofi/

popd ~/dotfiles
