# Tip: You can use the syntax above to avoid long if-statements.
# [[ condition ]] && execution

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Import aliases.
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.aliases ]] && . ~/.aliases

# Limit recursive functions.
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

# Delete duplicates from history and keep the newest.
export HISTCONTROL=erasedups:ignorespace

. "$HOME/.cargo/env"
# Starship prompt!
# https://starship.rs
eval "$(starship init bash)"

