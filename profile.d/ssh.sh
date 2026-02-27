
_1pass_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
if test -e "$_1pass_sock"; then
	SSH_AUTH_SOCK="$_1pass_sock"; export SSH_AUTH_SOCK
fi
unset _1pass_sock
