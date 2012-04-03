#!/bin/sh
ZSH_CUSTOM_CONFIG_DIR="${ZSH_CUSTOM_CONFIG_DIR:-$HOME/zsh-config}"

. $ZSH_CUSTOM_CONFIG_DIR/functions.sh

for file in `nullglob_expand '$ZSH_CUSTOM_CONFIG_DIR/zshrc.d/*.sh'`; do
	if [ -x "$file" ]; then
		. "$file";
	fi
done

# If this is a Zsh session be sure to get all the extra goodies.
if is_zsh; then
	for file in `nullglob_expand '$ZSH_CUSTOM_CONFIG_DIR/zshrc.d/*.zsh'`; do
		[ -x "$file" ] && . "$file";
	done
fi
unset file
