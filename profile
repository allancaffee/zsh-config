#!/bin/sh
# Set localized system wide features

export PATH=$PATH:/usr/local/Simili31/tcl/bin

export HISTSIZE=5500                    # Lines of history to save in mem
export SAVEHIST=5000                    # Lines of history to write out
export HISTFILE="$HOME/.zsh_history/zsh_history" # File to which history will be saved
test -d  $(dirname $HISTFILE) || mkdir -p $(dirname $HISTFILE)

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
