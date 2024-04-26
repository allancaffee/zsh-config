# Bash style colorized prompt
if is_bash; then
	count=1;
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
		eval $color="'\[\\e[3'${count}'m\]'"
		(( count = $count + 1 ))
	done
	NORM="\[\e[0m\]";

	# Root's prompt is red
	if [ "`id -u`" = "0" ]; then
		UCOLOR=$RED
	else
		UCOLOR=$GREEN
	fi
	PS1="[${UCOLOR}\u${NORM}@${BLUE}\h${NORM}:${CYAN}\w${NORM}]${UCOLOR}\\$ ${NORM}"

	# Zsh prompt
elif is_zsh; then
	setopt prompt_subst
	autoload colors zsh/terminfo
	colors
	# Get a value for each of the colors.
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
		eval $color='%{$fg[${(L)color}]%}'
		(( count = $count + 1 ))
	done

	# This part is to handle systems which don't have the terminfo module.
	# The escape sequence below is specified by ANSI so it should safe
	# anyway.
	if test -n "$terminfo[sgr0]"; then
		NORM="%{$terminfo[sgr0]%}"
	else
		NORM=$(echo '%{\033[0m%}')
	fi

	# Root's prompt is red
	if [ "`id -u`" = "0" ]; then
		UCOLOR=$RED
	else
		UCOLOR=$GREEN
	fi
	PS1="[$UCOLOR%n$NORM" #Username
	PS1="$PS1@$BLUE%m$NORM:$CYAN%~$NORM]" #Machine name and pwd
	# If vcs_info is available add the current branch to the prompt.
	if autoloadable vcs_info; then
		autoload vcs_info
		eval 'precmd_functions=($precmd_functions '\''vcs_info'\'')'
		zstyle ':vcs_info:*' formats '{'$MAGENTA'%b'$NORM'}'
		# Enable it just for git. It causes crashes with SVN on my machine.
		zstyle ':vcs_info:*' enable git
		RPROMPT='$vcs_info_msg_0_'
	fi
	PS1="$PS1(%B%?%b)" #Exit status of previous
	PS1="$PS1$UCOLOR%#$NORM "
elif [ "`id -u`" = "0" ]; then
	PS1='# '
else
	PS1='$ '
fi
export PS1

clean_prompt() {
	if [ "`id -u`" = "0" ]; then
		PS1='# '
	else
		PS1='$ '
	fi
	unset RPROMPT
	export PS1
}

# Clean up the environment
for var in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE NORM UCOLOR CurShell; do
	eval unset $var
done
