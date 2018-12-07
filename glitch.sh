#!/usr/bin/env bash

CHUNK_S=4  # number of bytes to remove at a time
MAX_ITR=5  # max number of times to cut file

if [ $# -lt 1 ] || ! [ -f $1 ]; then
    echo "Usage: $0 [image]"
    exit 0
fi

# assume input is a PNG
IMG=$1
NEW_IMG=${IMG/.png/.jpg}
# IMG_SIZE=$()

convert $IMG $NEW_IMG

i=0
while $((i < $MAX_ITR)); do

    
    
    i=$((i + 1))
done
