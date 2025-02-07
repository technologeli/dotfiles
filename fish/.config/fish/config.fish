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
	function y
		set tmp (mktemp -t "yazi-cwd.XXXXXX")
		yazi $argv --cwd-file="$tmp"
		if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
			builtin cd -- "$cwd"
		end
		rm -f -- "$tmp"
	end

	fish_add_path "$HOME/dotfiles/scripts"

	# start ssh-agent if not running
	if test "$(ps aux | grep ssh-agent | wc -l)" -eq "1" # 1 because of the grep itself
		eval (ssh-agent -c)
	end
end
set -gx VOLTA_HOME "$HOME/.volta"
fish_add_path "$VOLTA_HOME/bin"
fish_add_path /usr/local/go/bin
fish_add_path "$HOME/go/bin"
