#!/bin/bash

passdb="$HOME/.secrets/passwd.db"

if ! [ -f "$passdb" ]; then
    echo "no password database file at $passdb"
    exit 1
fi

print_usage() {
    echo "Usage: $0 [option] [search term]"
    echo ""
    echo "Options:"
    echo "  -h, --help      print this message"
    echo "  -u, --user      copy username of search term to clipboard"
    echo "  -l, --list      list titles of all entries"
    echo "  -g, --gen LEN   generate a password of byte length LEN"
    echo ""
    echo "Author & copyright: Anders Dalskov"
    exit 0
}

if [ $# -lt 1 ]; then
    print_usage
fi

cmd=""
search_term=""
case "$1" in
    -h|--help)
	print_usage
	;;
    -u|--user)
	cmd="u"
	[ -z "$2" ] && echo "missing search term" && exit 1
	search_term="$2"
	;;
    -p|--pass)
	cmd="p"
	[ -z "$2" ] && echo "missing search term" && exit 1
	search_term="$2"
	;;
    -l|--list)
	cmd="l"
	;;
    *)
	echo "don't know what to do with $1 ..."
	print_usage
	;;
esac

if [ "$cmd" == "l" ]; then
    gpg -d $passdb 2>/dev/null | grep -E '^t:.*' | cut -d ':' -f2 | sort
    exit 0
fi

content=$(gpg -d $passdb 2>/dev/null | sed -n "/^t:$search_term/,/^$cmd:/p")

if [ -z "$content" ]; then
    echo "nothing found for \"$search_term\""
    exit 0
fi

result=$(grep -E "^$cmd:" <<<$content | cut -d: -f2- | xargs -0 printf "%s")
echo -n "${result}" | xclip -selection c

ttl=10

clear_clipboard() {
    echo -n | xclip -selection c
    echo ""
    exit 0
}

trap clear_clipboard INT EXIT TERM

echo -n "clearing clipboard "
for i in $(seq $ttl); do
    echo -n "."
    sleep 1
done
echo " now"
