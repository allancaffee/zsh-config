# This file contains functions which should be available to all other functions
# and initialization code.

is_zsh () {
  ! test x"$ZSH_VERSION" = x""
}

is_bash () {
  ! test x"$BASH_VERSION" = x""
}

# Expand the arguments with respect to file name globbing.  TODO: Maybe this
# function should `unsetopt nomatch' or `emulate -L sh' to ensure identical
# behavior with other shells.
nullglob_expand () {
	# Save the value of the nullglob option.
	is_zsh && setopt localoptions nullglob
	eval "echo $@"
}

# Source each executable file in the directory $1 ending with $2.  If no
# extension is provided then source all files.  TODO: This should probably be
# changed to all files not ending in `~'.
source_executable_in_dir () {
	if ! test -d "$1"; then
		echo "Usage: $0 DIRECTORY EXTENSION" >&2
		return 1
	fi
	for file in `nullglob_expand "$1/*$2"`; do
		test -x "$file" && . "$file";
	done
	unset file
}

# Courtesy of Matt Woznisky.
# Checks if a file can be autoloaded by trying to load it in a subshell.
# If we find it, return 0, else 1
function autoloadable {
( unfunction $1 ; autoload -U +X $1 ) &>/dev/null
}

