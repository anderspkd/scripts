#!/usr/bin/env bash

shopt -s lastpipe

MAILDIR="$HOME/mail"
MAIL_STR=""
NUNREAD=0

count-unread-mails () {
    local maildir="${MAILDIR}/$1/"
    local unread=0

    find "${maildir}" -type d -print0 |
	while read -d '' -r d1; do
	    if ! [ -d "${d1}/new" ]; then
		continue
	    fi
	    IFS='/' read -ra dname <<< "${d1}"
	    dname="${dname[-1]}"
	    unset IFS
	    case "${dname}" in
		'sent'|'Sent'|'Sent Items'|'trash'|'Trash'|'drafts'|'Drafts' )
		    continue
		    ;;
	    esac
	    # unread=$((unread + $(find "${d1}/new" -type f | wc -l)))
	    nnew=$(find "${d1}/new" -type f | wc -l)
	    unread=$(($unread + $nnew))
	done
    NUNREAD=$unread
}

format-mail () {
    local num_unread=$NUNREAD
    local envelope="EMAIL $1:"
    local color="#FFFFFF"  # white
    if (( $num_unread > 0 )); then
	color="#00FF00"  # read
    fi
    s="\"${envelope} ${num_unread}\""
    MAILSTR="\"color\":\"$color\",\"full_text\":$s"
}

i3status | (
read line && echo "$line" &&  # {"version": ....}
read line && echo "$line" &&  # [
read line && echo "$line" &&  # [ old i3 stuff ... ]
while :
do
    read line
    count-unread-mails "work"
    format-mail "w"
    s1=$MAILSTR
    count-unread-mails "fastmail"
    format-mail $unread "p"
    s2=$MAILSTR
    echo ",[\
{\"name\":\"mail\" ,$s1},\
{\"name\":\"mail\" ,$s2},\
${line#,\[}" || exit 1
done
)
