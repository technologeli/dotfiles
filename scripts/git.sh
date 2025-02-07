#!/usr/bin/env bash

# colors!
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m' # reset

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
	fi
	popd > /dev/null 2>&1
	echo
}

run ~/dotfiles
run ~/topaz
run ~/.password-store
