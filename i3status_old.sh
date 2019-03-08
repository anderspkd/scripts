#!/usr/bin/env bash

# Script that augments i3bar with information about number of unread
# e-mails. Adapted from
# https://github.com/i3/i3status/blob/master/contrib/net-speed.sh
#

ENVELOPE="EMAIL:"
MAILDIR="$HOME/mail"

MAIL_JSON=""

format-mail-json () {
    local unreadw="$1"
    local unreadp="$2"
    local color="$3"
    MAIL_JSON="\"color\":\"$color\",\"full_text\":\"$ENVELOPE $unreadp / $unreadw\""
}

count-unread-mails () {
    local newdirs1="$MAILDIR/fastmail/*/new/"
    local newdirs2="$MAILDIR/work/*/new/"
    local unreadp=0
    local unreadw=0

    for mdir in $(find $newdirs1 -type d | grep -v 'sent\|trash\|drafts'); do
	unreadp=$((unreadp + $(find "$mdir" -type f | wc -l)))
    done
    for mdir in $(find $newdirs2 -type d | grep -v 'Sent\|Trash\|Drafts'); do
	unreadw=$((unreadw + $(find "$mdir" -type f | wc -l)))
    done

    if (( $unreadp > 0 )) | (( $unreadw > 0 )); then
	format-mail-json $unreadp $unreadw "#00FF00"
    else
	format-mail-json 0 0 "#FFFFFF"
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
