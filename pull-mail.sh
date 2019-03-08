#!/bin/bash

# basically the script from http://www.offlineimap.org/configuration/2016/01/29/why-i-m-not-using-maxconnctions.html

offlineimap -a $1 &
pid1=$!

offlineimap -a $2 &
pid2=$!

wait $pid1
wait $pid2

echo "last run $(date)"
