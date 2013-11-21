#!/bin/bash

NOTIFY_ICON_UNKNOWN=/home/ben/.icons/question-mark.png
NOTIFY_ICON_UNMUTED=/home/ben/.icons/warning-sign.jpg
NOTIFY_ICON_MUTED=/home/ben/.icons/green-checkmark.png

NOTIFY_TIMEOUT=$((4*1000))
NOTIFY_APP_NAME=`basename $0 .sh`

currentStatus=`amixer sset Capture toggle | egrep -m1 -o "\[(on|off)\]$"`
useIcon=$NOTIFY_ICON_UNKNOWN
notifyTitle="Microphone Unknown"
notifyBody="Not sure if the microphone is muted or not..."

if [ "$currentStatus" == "[on]" ]; then
	useIcon=$NOTIFY_ICON_UNMUTED
	notifyTitle="Microphone UNMUTED"
	notifyBody="The microphone has been unmuted"
elif [ "$currentStatus" == "[off]" ]; then
	useIcon=$NOTIFY_ICON_MUTED
	notifyTitle="Microphone Muted"
	notifyBody="The microphone has been muted"
fi

notify-send \
		--expire-time=${NOTIFY_TIMEOUT} \
		--app-name="${NOTIFY_APP_NAME}" \
		--icon="${useIcon}" \
		"${notifyTitle}" \
		"${notifyBody}"

