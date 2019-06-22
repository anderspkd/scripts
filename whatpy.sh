#!/bin/bash

docdir="$HOME/docs/lib/other/python-3.7.4rc1-docs-text"

phrase="$1"

if [ -z "$phrase" ]; then
    echo "usage: $0 [phrase]"
    exit 0
fi

matches=$(find "$docdir" -iname "*$phrase*")

if [ -z "$matches" ]; then
    echo "no matches in \"$docdir\" for search phrase \"$phrase\""
    exit 0
fi

# TODO: buffer stuff to stdout?
i=0
for m in $matches; do
    fn=$(basename $m)
    printf "%3d) %s\n" $i ${fn%.*}
    i=$((i+1))
done

echo -n "? "
read -r choice

if [ "$choice" = "q" ]; then
    exit 0
fi

if [[ "$choice" =~ "[0-9].*" ]]; then
    echo "invalid selection: $choice"
fi

fileloc=
i=0
for m in $matches; do
    if [ $choice = $i ]; then
	fileloc=$m
	break
    fi
    i=$((i+1))
done

if [ -z "$fileloc" ]; then
    echo "invalid selection: $choice"
    exit 1
fi

less $fileloc
