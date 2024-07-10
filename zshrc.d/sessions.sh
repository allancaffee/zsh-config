set_session_title() {
	echo -ne "\033]0;$@\007"
}

nts() {
	_session_name=$(basename $(pwd))
	set_session_title $_session_name
	tmux new-session -As $_session_name
	unset _session_name
}
