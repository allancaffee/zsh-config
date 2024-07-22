#!/bin/sh
# Set localized system wide features
ZSH_CUSTOM_CONFIG_DIR="${ZSH_CUSTOM_CONFIG_DIR:-$HOME/zsh-config}"

export PATH=$PATH:/usr/local/Simili31/tcl/bin

. $ZSH_CUSTOM_CONFIG_DIR/functions.sh

if is_zsh; then
	export FPATH=$ZSH_CUSTOM_CONFIG_DIR/comp:$FPATH
	typeset -U fpath

	typeset -T LD_LIBRARY_PATH ld_library_path
	typeset -U ld_library_path
fi

source_executable_in_dir $ZSH_CUSTOM_CONFIG_DIR/profile.d sh

# If this is a Zsh session be sure to get all the extra goodies.
is_zsh && source_executable_in_dir $ZSH_CUSTOM_CONFIG_DIR/profile.d zsh

# Add our local scripts etc.
export PATH=$ZSH_CUSTOM_CONFIG_DIR/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
eval "$(/opt/homebrew/bin/brew shellenv)"
