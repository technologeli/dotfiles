#!/usr/bin/env bash

source $HOME/dotfiles/scripts/init.sh
$SCRIPTS/temp-ssh.sh

# defaults
pull=false
push=false

while [ $# -gt 0 ]; do
	case "$1" in
		--pull)
			pull=true
			shift
			;;
		--push)
			push=true
			shift
			;;
		--all)
			pull=true
			push=true
			shift
			;;
		*)
			echo "Unknown option: $1"
			exit 1
			;;
	esac
done

run() {
	echo -e "${GREEN}========== ${YELLOW}$1${GREEN} ==========${RESET}"
	pushd $1 > /dev/null 2>&1
	if [ "$pull" = true ]; then
		git pull
	fi
	git status
	if [ "$push" = true ]; then
		git add .
		git commit
		git push
	fi
	popd > /dev/null 2>&1
	echo
}

run $HOME/dotfiles
run $HOME/topaz
run $HOME/.password-store
