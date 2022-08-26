if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.aliases
    fish_add_path ~/.cargo/bin

    fish_vi_key_bindings

    function fish_greeting
    end

    starship init fish | source
end

# pnpm
set -gx PNPM_HOME "/home/eli/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end