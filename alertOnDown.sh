#!/bin/bash

DEFAULT_ALERT_SOUND=~/.sounds/RailroadCrossingBell.wav

HOST=
SSH_CONNECT_TIMEOUT=10
NOTIFY_SEND=no
PLAY_ALERT_SOUND=no
ALERT_SOUND=
POLL_INTERVAL=30
EXPECT_HOSTNAME=

alertOnDown_showUsage ()
{
	cat << EOF
	usage: $0
		-a 				# Play sound when server down
		-S {snd file}	# Specify what sound file to play
		-n 				# Use notify-send to launch notification
		-H {hostname}   # Hostname to watch for
		-i {seconds}	# Polling interval
		-e {hostname}	# Expected result of \`hostname\` on system
		-h				# View help
EOF
}

while getopts ":aS:nH:hi:e:" opt; do
	case $opt in
		e) EXPECT_HOSTNAME=$OPTARG ;;
		i) POLL_INTERVAL=$OPTARG ;;
		a)
			PLAY_ALERT_SOUND=yes
			[[ -z $ALERT_SOUND ]] && ALERT_SOUND=$DEFAULT_ALERT_SOUND
			;;
		S) ALERT_SOUND=$OPTARG ;;
		n) NOTIFY_SEND=yes ;;
		H) HOST=$OPTARG ;;
		h)
			alertOnDown_showUsage
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

if [ -z $HOST ]; then
	echo "You must specify a hostname to monitor" 1>&2
	exit 100
fi

if [ "$PLAY_ALERT_SOUND" == "yes" ]; then
	paplayPath=`which paplay 2>>/dev/null`
	if [ -z $paplayPath ]; then
		echo "paplay not found in PATH=$PATH" 1>&2
		exit 101
	fi

	if [ ! -f "$ALERT_SOUND" ]; then
		echo "ALERT_SOUND=$ALERT_SOUND is not a file" 1>&2
		exit 102
	fi

fi

if [ "$NOTIFY_SEND" == "yes" ]; then
	notifySendPath=`which notify-send 2>>/dev/null`
	if [ -z $notifySendPath ]; then
		echo "notify-send not found in PATH=$PATH" 1>&2
		exit 103
	fi
fi

[ -z $EXPECT_HOSTNAME ] && EXPECT_HOSTNAME=`echo $HOST | cut -f1 -d"."`
while :; do
	foundHostname=`ssh -o ConnectTimeout=$SSH_CONNECT_TIMEOUT $HOST hostname 2>>/dev/null`
	echo -e "[`date`]\t$foundHostname"
	[ "$foundHostname" != "$EXPECT_HOSTNAME" ] && break
	sleep $POLL_INTERVAL
done

if [ "$NOTIFY_SEND" == "yes" ]; then
	notify-send -t 0 "System Offline" "`date` - $HOST"
fi

if [ "$PLAY_ALERT_SOUND" == "yes" ]; then
	paplay "$ALERT_SOUND" &
fi

