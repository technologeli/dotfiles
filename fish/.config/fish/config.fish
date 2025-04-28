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
	set -Ux SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
end
set -gx JAVA_HOME "/opt/jdk-21.0.6+7/"
set -gx VOLTA_HOME "$HOME/.volta"
fish_add_path "$VOLTA_HOME/bin"
fish_add_path /usr/local/go/bin
fish_add_path "$HOME/go/bin"
fish_add_path "$JAVA_HOME/bin"

# emacs
function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end
if [ "$INSIDE_EMACS" = 'vterm' ]
    function clear
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
    end
end
function vterm_prompt_end;
    vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
end
functions --copy fish_prompt vterm_old_fish_prompt
function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
    # Remove the trailing newline from the original prompt. This is done
    # using the string builtin from fish, but to make sure any escape codes
    # are correctly interpreted, use %b for printf.
    printf "%b" (string join "\n" (vterm_old_fish_prompt))
    vterm_prompt_end
end
function vterm_cmd --description 'Run an Emacs command among the ones been defined in vterm-eval-cmds.'
    set -l vterm_elisp ()
    for arg in $argv
        set -a vterm_elisp (printf '"%s" ' (string replace -a -r '([\\\\"])' '\\\\\\\\$1' $arg))
    end
    vterm_printf '51;E'(string join '' $vterm_elisp)
end
function find_file
    set -q argv[1]; or set argv[1] "."
    vterm_cmd find-file (realpath "$argv")
end