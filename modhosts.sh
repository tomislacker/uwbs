#!/bin/bash

ASK_FIRST=no

ADD_HOST=
ADD_ADDR=

REM_HOST=
REM_ADDR=

SHOW_LIST=no
SHOW_LIST_LOOPBACK=no

SHOW_USAGE=no

modhosts_showUsage ()
{
	cat << EOF
	usage: $0
		-a <hostname>	# New hostname to add (requires -i)
		-i <ipaddr>	# New IP for new hostname (requires -a)
		-r <hostname>	# Remove a hostname
		-R <ipaddr>	# Remove all hosts for an IP addr
		-l		# List static hosts
		-L		# Include loopback hosts (if used without -l
				# will only show loopback hosts)
		-h 		# Show this [help] dialog.
EOF
}

while getopts ":a:i:r:R:y:Llh" opt; do
	case $opt in
		a)	ADD_HOST=$OPTARG ;;
		i)	ADD_ADDR=$OPTARG ;;
		r)	REM_HOST=$OPTARG ;;
		R)	REM_ADDR=$OPTARG ;;
		l)	SHOW_LIST=yes ;;
		L)	SHOW_LIST_LOOPBACK=yes;;
		y)	ASK_FIRST=yes ;;
		h)
			modhosts_showUsage
			exit 0
			;;
		\?)
			echo "Invalid option: -${OPTARG}" 1>&2
			echo "Run '$0 -h' for usage..." 1>&2
			exit 1
			;;
		:)
			echo "Option -${OPTARG} requires an argument." 1>&2
			echo "Run '$0 -h' for usage..." 1>&2
			exit 1
			;;
	esac
done

#####
# Sanity check the variables we've received now.
#####
if [ -n "$ADD_HOST" -a -n "$ADD_ADDR" ]; then
	egrep "\s+${ADD_HOST}(\s+|$)" /etc/hosts >>/dev/null 2>&1
	
	if [[ $? -eq 0 ]]; then
		echo "Host '${ADD_HOST}' already exists... Remove it first" 1>&2
		exit 50
	fi
	echo -e "${ADD_ADDR}\t${ADD_HOST}" | sudo tee -a /etc/hosts >>/dev/null 2>&1
fi

if [ -n "$REM_HOST" -o -n "$REM_ADDR" ]; then
	if [ -n "$REM_ADDR" ]; then
		sudo sed -i "/^\s*${REM_ADDR}\s/d" /etc/hosts
	elif [ -n "$REM_HOST" ]; then
		sudo sed -i "/\s${REM_HOST}\s*\$/d" /etc/hosts
	fi
fi

if [ "$SHOW_LIST" == "yes" -o "$SHOW_LIST_LOOPBACK" == "yes" ]; then
	if [ "$SHOW_LIST" == "yes" -a "$SHOW_LIST_LOOPBACK" == "yes" ]; then
		egrep -v -e "^\s*(#.*)?$" /etc/hosts | sort
	elif [ "$SHOW_LIST" == "yes" ]; then
		egrep -v -e "^\s*(::1|127\.0\.0\.1)" -e "^\s*(#.*)?$" /etc/hosts | sort
	elif [ "$SHOW_LIST_LOOPBACK" == "yes" ]; then
		egrep "^\s*127.0.0.1" /etc/hosts | sort
	fi
fi
