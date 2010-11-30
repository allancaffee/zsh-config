#!/bin/sh
SSH=ssh

## update_host (host, user, remote_dir)
update_host () {
	host="$1"
	user="$2"
	remote_dir="$3"
	if ! ping -c 1 $host >/dev/null 2>/dev/null; then
		echo "Ping failed against $host" >&2
		return 1;
	fi

	echo "$host: Pulling from `hostname`"
	$SSH $user@$host -qt "cd $remote_dir && git-pull"
	echo
}

# Return true if the current working tree has no changes to commit.
is_wc_clean () {
	git-status | grep '^nothing\( added\)\? to commit' >/dev/null
}

pull_changes () {
	host="$1"
	echo "Pulling from $host:"
	git-pull "$host" ":$host/master"
	echo
}

if ! is_wc_clean; then
	cat <<__EOF
Working tree has uncommited changes.  No changes will be pulled from remote
hosts.

__EOF
else
	pull_changes knoppix
	pull_changes esgrsdv
fi

update_host 'knoppix.ml.dupont.com' 'fc0737' '/usr/local/etc/zsh'
update_host 'esgrsdv.es.dupont.com' 'fc0737' '$HOME/zsh'

