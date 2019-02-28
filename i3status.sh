#!/usr/bin/env bash

# Script that augments i3bar with information about number of unread
# e-mails. Adapted from
# https://github.com/i3/i3status/blob/master/contrib/net-speed.sh
#

ENVELOPE="EMAIL:"
MAILDIR="$HOME/mail"

MAIL_JSON=""

format-mail-json () {
    local unread="$1"
    local color="$2"
    MAIL_JSON="\"color\":\"$color\",\"full_text\":\"$ENVELOPE $unread\""
}

count-unread-mails () {
    local newdirs1="$MAILDIR/fastmail/*/new/"
    local newdirs2="$MAILDIR/work/*/new/"
    local unread=0

    for mdir in $(find $newdirs1 -type d | grep -v 'sent\|trash\|drafts'); do
	unread=$((unread + $(find "$mdir" -type f | wc -l)))
    done
    for mdir in $(find $newdirs1 -type d | grep -v 'Sent\|Trash\|Drafts'); do
	unread=$((unread + $(find "$mdir" -type f | wc -l)))
    done

    if (( $unread > 0 )); then
	format-mail-json $unread "#00FF00"
    else
	format-mail-json 0 "#FFFFFF"
    fi
}

i3status | (read line && echo "$line" && read line && echo "$line" && read line && echo "$line" && count-unread-mails &&
while :
do
    read line
    count-unread-mails
    echo ",[{\"name\":\"mail\",${MAIL_JSON}},${line#,\[}" || exit 1
done
)
