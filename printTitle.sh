#!/bin/bash

printTitle ()
{
	if [ "${1:0:1}" != "-" ]; then
		printTitle -t "$*"
		return
	fi

	local BORDER_HCHAR="#"
	local BORDER_COLOR="[1;30m\033[1m"

	local TITLE_STRING=
	local TITLE_COLOR="[37;0m\033[1m"

	local BORDER_STRING_LEFT=
	local BORDER_STRING_RIGHT=

	local USE_COLOR=yes
	local arg=""
	local OPTARG=""
	local OPTIND=""

	while getopts ":c:l:r:b:T:t:N" arg; do
		case $arg in
			N)	USE_COLOR=no ;;
			c)	BORDER_HCHAR=$OPTARG ;;
			l)	BORDER_STRING_LEFT=$OPTARG ;;
			r)	BORDER_STRING_RIGHT=$OPTARG ;;
			b)	BORDER_COLOR=$OPTARG ;;
			T)	TITLE_COLOR=$OPTARG ;;
			t)	TITLE_STRING=$OPTARG ;;
			\?)
				echo "Invalid option: -${arg}" 1>&2
				exit 1
				;;
			:)
				echo "Option -${OPTARG} requires an argument." 1>&2
				exit 1
				;;
		esac
	done
	unset OPTIND

	if [ "$USE_COLOR" != "yes" ]; then
		BORDER_COLOR=
		TITLE_COLOR=
	fi

	# If the left and right border strings were not specified, default to using
	# the horizontal border character padded with a space to the 'inside'
	[ -z "$BORDER_STRING_LEFT" ] && BORDER_STRING_LEFT="${BORDER_HCHAR} "
	[ -z "$BORDER_STRING_RIGHT" ] && BORDER_STRING_RIGHT=" ${BORDER_HCHAR}"

	# Construct our upper and lower horizonal border string
	local horizBorderString=
	local horizBorderStringLength=$((${#BORDER_STRING_LEFT}+${#BORDER_STRING_RIGHT}+${#TITLE_STRING}))
	while [[ ${#horizBorderString} -lt ${horizBorderStringLength} ]]; do
		horizBorderString="${horizBorderString}${BORDER_HCHAR}"
	done

	# If there's a BORDER_COLOR, print it
	[ ! -z $BORDER_COLOR ] && echo -e -n "\e${BORDER_COLOR}"

	# Print the horizontal (possibly top) border
	echo -e -n "${horizBorderString}"

	# If there is no title string, output the CLEAR and new line, then return 0
	[[ ${#TITLE_STRING} -gt 0 ]] && ( echo -e "\033[0m" ; return 0 )

	# If the BORDER_COLOR != TITLE_COLOR, make sure to CLEAR the ANSI codes.
	[[ ${#BORDER_COLOR} -gt 0 ]] && echo -e -n "\033${BORDER_COLOR}"
	echo -e -n "${BORDER_STRING_LEFT}"

	# If the BORDER_COLOR != TITLE_COLOR, make sure to CLEAR the ANSI codes.
	[ "$BORDER_COLOR" != "$TITLE_COLOR" ] && echo -e -n "\033[0m"
	[[ ${#TITLE_COLOR} -gt 0 ]] && echo -e -n "\033${TITLE_COLOR}"
	echo -e -n $TITLE_STRING
	[ "$BORDER_COLOR" != "$TITLE_COLOR" ] && echo -e -n "\033[0m"
	[[ ${#BORDER_COLOR} -gt 0 ]] && echo -e -n "\033${BORDER_COLOR}"
	echo -e "${BORDER_STRING_RIGHT}\n${horizBorderString}\033[0m"
}

echo "[Arg Count=$#]"
if [[ $# -ne 0 ]]; then
	printTitle $*
fi

#echo "Calling printTitle $*"
#printTitle $*

