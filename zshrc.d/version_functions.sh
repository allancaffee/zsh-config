## This file contains all of the version control convenience functions.  These
## were designed to abstract away the commonly used features of these systems.

is_svn_repos () {
  # This is a pretty lame attempt to determine whether we want to use
  # git or svn to diff.  It's lame because we don't actually tell
  # whether or not we're even diffing a file in the current dir.  But
  # in the name of avoiding something a little more hackish, we'll
  # pretend we don't know any better.
  test -d .svn
}

## Determine whether the tree we are working on belongs to a git
## repository.  We want to do this correctly regardless of whether git is
## actually installed.  Since git commands only work inside a working
## tree we can just recursively walk up the tree looking for the `.git'
## directory.
is_git_repos () {
	local working_dir=${1:-$PWD}
	if test -d $working_dir/.git
	then
		return 0
	elif test "$working_dir" = "/"
	then
		return 1
	fi

	is_git_repos $(dirname $working_dir)
}

## Display a colorized diff of the changes since the last commit.
vdiff() {
  if is_git_repos; then
    git diff --color $@
  else # (probably) not git
    # Determine the pager to use
    if which vless >/dev/null 2>/dev/null; then
      pager='vless -c "set filetype=diff"'
    else
      pager=less
    fi

    if ! svn diff $@ | cmp - /dev/null 2>/dev/null >/dev/null; then
      svn diff $@ | eval $pager -
    fi
    unset pager
  fi
}

## Version control status.
vst() {
	if is_git_repos; then
		git status $@
	else
		svn st $@
	fi
}

## Check the log.
vlog() {
	if is_git_repos; then
		git log $@
	else
		local svnargs
		# Use the merge history if it's available.
		if svn log --help | grep 'use-merge-history' >/dev/null; then
			svnargs='--use-merge-history'
		fi
		svn log $svnargs $@ | ${PAGER:-less}
	fi
}

# Reapply a commit to this branch.
git_reapply_patch () {
	if test -z "$1"; then
		echo "No revision specified!" >&2;
	fi
	git diff-tree -p "$1" | git apply --index
}

# Reapply a commit to this branch and, if there are no conflicts, commit
# reusing the old log message.
git_reapply_and_commit () {
	if test -z "$1"; then
		echo "No revision specified!" >&2;
	fi
	git_reapply_patch "$1" && git commit --reuse-message="$1"
}

# Remove files which are not under version control from a working copy.
# Inspired by git-clean.
svn_clean () {
	for f in $(svn status | awk '/^?/ {print $2}')
	do
		rm $@ $f
	done
}


# Push a feature branch to master and kill it.
pm () {
	branch_name=`git rev-parse --abbrev-ref HEAD`
        git review dcommit
        git fetch && git rebase origin/master && git push origin "$branch_name:master" && git checkout master && git branch -D "$branch_name"
}
