# Install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Install plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Completion
FPATH=~/.rbenv/completions:"$FPATH"
autoload -Uz compinit && compinit
zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Alias
alias ls="exa"
alias bat="batcat --theme gruvbox-dark"

# Add to PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/lua-language-server-3.15.0/bin"
export PATH="$PATH:$HOME/.local/kotlin-language-server/bin"
export PATH="$PATH:$HOME/.local/zig/"

eval "$(oh-my-posh init zsh --config $HOME/dotfiles/oh-my-posh/config.toml)"
eval "$(zoxide init --cmd cd zsh)"

# Set nvim as manpager
export MANPAGER="nvim +Man!"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

# Added by `rbenv init` on Wed Aug  6 03:16:37 PM EDT 2025
eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"
