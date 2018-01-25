#!/bin/bash

set -o pipefail

SSH_ARGS=$@

get_tz_via_file ()
{
    ssh ${SSH_ARGS} cat /etc/timezone 2>>/dev/null
}

get_tz_via_systemd ()
{
    ssh ${SSH_ARGS} timedatectl 2>>/dev/null \
        | egrep '^\s*Time zone:' \
        | cut -d':' -f2 \
        | awk '{ print $1 }'
}

if [ -z "$TZ" ]
then
    # No TZ env var found yet, try checking the file
    TZ=$(get_tz_via_file)
fi

if [ -z "$TZ" ]
then
    # No TZ env var found yet, try checking via systemd (timedatectl)
    TZ=$(get_tz_via_systemd)
fi

if [ -z "$TZ" ]
then
    # No TZ env var found, fail
    echo >&2 "ERROR: Could not determine what TZ should be set remotely"
    exit 1
fi

ssh -t ${SSH_ARGS} "sudo date -s \"$(TZ=${TZ} date +'%Y%m%d %H:%M:%S')\""
