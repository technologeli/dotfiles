#!/usr/bin/env bash

pushd ~/dotfiles

stow -R aliases/ fish/ kitty/ nvim/ starship/ tmux/

popd ~/dotfiles
