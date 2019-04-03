#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "no mailboxes provided. Nothing to do"
    exit 0
fi

mailboxes=${@:1}

pull-mail () {
    offlineimap -a $@
    echo "done at $(date)"
}

echo "started at $(date)"

while true
do
    found=0
    read x
    if [ -z $x ]; then
	for n in ${mailboxes[@]}
	do
	    echo "polling $n ..."
	    pull-mail $n
	done
    else
	for n in ${mailboxes[@]}
	do
	    if [ "$n" = "$x" ]; then
		echo "polling $x ..."
		pull-mail $x
		found=1
	    fi
	done
	if [ "$found" == "0" ]; then
	    echo "no mailbox found for $x"
	fi
    fi
done
