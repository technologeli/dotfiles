# Turn off the greeting
set fish_greeting

# Add executables to path to path
fish_add_path ~/.local/bin

if status is-interactive
	set -Ux EDITOR nvim
	set -Ux MANPAGER "nvim +Man!"
	fish_vi_key_bindings
	zoxide init fish --cmd cd | source
	fzf_key_bindings
	starship init fish | source

	alias ls "eza --color=auto"
	alias grep "grep --color=auto"
	alias bat "batcat --theme=gruvbox-dark"
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
