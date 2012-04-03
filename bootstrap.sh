#!/bin/bash
# Bootstrap the shell configuration by linking it into the home directory.
# This script must be run from the `zsh-config` directory

function link_file() {
	file=$1
        target=${2:-.$file}
        # We create the file if it doesn't exists. We also check if the file is
        # a symlink because `test -e symlinked-file` in zsh version 4.3.11 on
        # OS X strangely returns 1.
	(test -e "$HOME/$target" || test -L "$HOME/$target") || ln -s "$PWD/$file" "$HOME/$target"
	unset file
        unset target
}

link_file profile .zprofile
link_file profile
link_file zshrc
link_file zshrc .bashrc
