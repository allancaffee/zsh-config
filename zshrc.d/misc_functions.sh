## Recursively remove backup files.
delbak ()
{
	# FIXME: The statement below has know quoting issues.
	target_dir=${@:-.}
	find $target_dir -name '*~' -exec rm -f {} + 2>/dev/null
	unset target_dir
}

# cd to the zsh customization directory or some directory specified
# relative to it.
cz () {
	cd $ZSH_CUSTOM_CONFIG_DIR/$1
}

# cd to the directory containing my Emacs Lisp if its available on this
# machine.
ce () {
	if test -d /usr/local/elisp; then
		cd /usr/local/elisp
	elif test -d $HOME/elisp; then
		cd $HOME/elisp
	else
		echo "$0: Could not find the elisp directory." >&3
		return 1
	fi
}

## Echo one file per line.
zglob() {
  for word in $@; do
    echo $word
  done;
}

# Shuffle lines from STDIN
shuffle() {
  awk 'BEGIN{srand()} {print rand() "\t" $0}' | sort -n | cut -f '2-'
}

checkcols() {
	for f in $@
	do
		/usr/bin/fold -w 72 $f | /usr/bin/diff - $f
	done
}

# Sign one or more packages for release.
sign_package () {
	if test -z "$@"; then
		echo "Usage: $0 PACKAGE [PACKAGE3 ...]" >&2
		return 1
	fi
	for package in $@; do
		gpg -a -b "$package"
	done
}

pstat ()
{
    for f in *; do
        if test -d $f -a -d $f/.svn; then
            echo $f:
            svn stat $f
        fi
    done
}

psgrep ()
{
	ps -ea | grep $@
}

# Create a unified diff of the specified files and pipe the output to vless for
# paging.
vldiff () {
	diff -u $@ | ${VLESS:-vless} -c 'set filetype=diff' -
}

dvidiff () {
	first=`mktemp`
	dvi2tty -w $COLUMNS $1 >$first
	if test $? -ne 0; then
		rv=$?
		rm -f $first
		return $rv
	fi
	dvi2tty -q -w $COLUMNS $2 | vldiff -w $first -
	rm -f $first
	unset first
}

## Print or edit the TODO list.
todo ()
{
	todo_file=$HOME/TODO;
	while getopts ':aerdg' OPT; do
		shift $OPTIND
		case $OPT in
			e)
			${EDITOR:-vim} $todo_file
			unset todo_file
			return 0
			;;
			a)
			echo "$@" >> $todo_file
			unset todo_file
			return 0
			;;
			d)
			sed -i~ "/$@/d" $todo_file
			unset todo_file
			return 0
                        ;;
			g)
			grep_for="$@"
			;;
		esac
	done

    if ! test -e "$todo_file"; then
	    unset todo_file
      return 0;
    fi

  cat <<EOF

todo list
==========
EOF
	if test x"$grep_for" != x""; then
		grep -i "$grep_for" < $todo_file
	else
		cat < $todo_file
	fi
	unset print_cmd grep_for
}

radio () {
	RFKILL=/sbin/rfkill

	# If there is no rfkill then there's no wireless to begin with.
	if ! test -x "$RFKILL"
	then
		unset RFKILL
		return 0
	fi

	if $RFKILL list 2>/dev/null | grep -A 2 wifi | grep yes >/dev/null
	then
		echo "Radio OFF"
	else
		echo "Radio ON"
	fi
	unset RFKILL
}

# Determine which libraries are on the path.
whichlib () {
  # We use the standard scalar LD_LIBRARY_PATH because the array
  # ld_library_path is only available on Zsh.
  for dir in `echo $LD_LIBRARY_PATH | tr ':' ' '`; do
    # Test that the current peice of the path is an existing directory and that
    # it contains library files.
    if test -d $dir &&  \
      ! (echo $dir/lib* | grep '\*$' >/dev/null 2>/dev/null)
    then
      # Ensure that only matches found in the basename are printed.  Pipe the
      # output to cat to prevent GNU grep from coloring the match without using
      # non-portable long options.
      ls -1 $dir/lib* | grep -e "$1[^/]*$" | cat
    fi
  done
}

# Locate files ending with the specified extension.
locateext () {
  if test -z "$1"; then
    echo "Usage: $0 <EXT>"
    echo " e.g.: $0 py  -- locate python scripts"
    return 1
  fi

  locate "$1" | grep "$1$"
}

# List the disk usage of everything in the specified directory in
# ascending order.
usage_breakdown () {
  target=${1:-.}
  if ! test -d "$target"; then
    echo "$0: target \`$target' is not a directory or does not exist" >&2
  fi
  IFS='
'
  for file in `du -s $target/* | sort -n | cut -f 2-`
  do
    du -sh $file
  done
  unset IFS
}

# Use emacs as an Info browser.
einfo () {
	emacs --eval "(info \"$@\")"
}

# Make a directory and then move to that directory.
mcd () {
	mkdir -p $1 && cd $1
}
