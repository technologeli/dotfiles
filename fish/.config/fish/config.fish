if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.aliases
    fish_add_path ~/.cargo/bin

    fish_vi_key_bindings

    function fish_greeting
    end

    starship init fish | source
end

set -gx PATH "/home/eli/.local/bin" $PATH

# pnpm
set -gx PNPM_HOME "/home/eli/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# go
set -gx PATH "/usr/local/go/bin" $PATH

# zoxide
zoxide init fish --cmd j | source
