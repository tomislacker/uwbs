#!/bin/bash

NOTIFY_ICON=`readlink -m ~`/.icons/svnxicon2.png
NOTIFY_TITLE="What the Commit"
NOTIFY_SECONDS=10

getCommitMessage ()
{
	wget -q -O/dev/stdout  http://www.whatthecommit.com/ | tr "\n" " " | egrep -o "<p>[^<]+" | sed 's/<p>//g'
}

showCommitMessage ()
{
	local commitMessage=$(getCommitMessage)
	notify-send -t $((${NOTIFY_SECONDS}*1000)) -i "${NOTIFY_ICON}" "${NOTIFY_TITLE}" "${commitMessage}"
}

showCommitMessage

