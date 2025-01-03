#!/usr/bin/env bash


pushd ~/dotfiles
git status
popd

echo
echo
echo
echo

pushd ~/topaz
git status
popd

echo
echo
echo
echo

pushd ~/.password-store
git status
popd
