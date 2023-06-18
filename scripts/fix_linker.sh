#! /usr/bin/env nix-shell
#! nix-shell -i bash -p patchelf

# from https://github.com/williamboman/mason.nvim/issues/428#issuecomment-1258919407

for binary in ${@}
do
  patchelf \
    --set-interpreter "$(cat ${NIX_CC}/nix-support/dynamic-linker)" \
    "${binary}"
done
