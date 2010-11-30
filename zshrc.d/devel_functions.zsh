rmdebug () {
	if test -z "$@"; then
		echo "Usage: removedebug FILE1 [FILE2 FILE3...]"
	fi

	sed -i '/DEBUGGING-CODE-DO-NOT-COMMIT/d' "$@"
}
