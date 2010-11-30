#!/usr/bin/zsh

sources=(`find . -name '*.sh' -o -name '*.zsh' -a ! -name $(basename $0)`)
for source_file in $sources; do
	if test ! -e $source_file.zwc \
		|| test $source_file -nt $source_file.zwc
	then
		echo zcompile $source_file
		zcompile $source_file
	fi
done
