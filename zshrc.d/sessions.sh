export HISTSIZE=5500                    # Lines of history to save in mem
export SAVEHIST=5000                    # Lines of history to write out
export HISTFILE="$HOME/.zsh_history/zsh_history" # File to which history will be saved
test -d  $(dirname $HISTFILE) || mkdir -p $(dirname $HISTFILE)

set_session_title() {
	echo -ne "\033]0;$@\007"
}

nts() {
	_session_name=$(basename $(pwd))
	set_session_title $_session_name
	tmux new-session -As $_session_name
	unset _session_name
}
