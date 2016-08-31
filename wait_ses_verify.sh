#!/bin/bash

###############################################################################
# Wait script for monitoring the verification status of an SES address        #
###############################################################################
# Arguments:
#   $1  Email address to check for Pending vs. other statuses
#   $2  Verification status to monitor for a change from.
#       Defaults to "Pending"
#
# Env Vars:
#   POLL_INTERVAL   Seconds before re-checking address status. (Default 300s)
###############################################################################

DEFAULT_LEAVE_STATUS=Pending
DEFAULT_POLL_INTERVAL=300

get_verification_status ()
{
    aws ses get-identity-verification-attributes --identities $@ \
        | sed 's/"//g' \
        | grep VerificationStatus \
        | awk '{ print $2 }'
}

msg_stamp ()
{
    date --iso-8601=seconds
}

msg_out ()
{
    echo -e "[$(msg_stamp)] $@"
}

msg_err ()
{
    msg_out $@ >&2
}

msg_fatal ()
{
    local exit_val=$1
    shift
    msg_err $@
    exit $exit_val
}

POLL_INTERVAL=${POLL_INTERVAL:-${DEFAULT_POLL_INTERVAL}}
CHECK_ADDR=$1
LEAVE_STATUS=${2:-${DEFAULT_LEAVE_STATUS}}

if [ -z "$CHECK_ADDR" ]
then
    msg_fatal 1 "ERROR: No address specified" 
elif [ -z "$LEAVE_STATUS" ]
then
    msg_fatal 1 "ERROR: LEAVE_STATUS is empty"
fi

while :;
do
    # Get the address's verification status
    current_status=$(get_verification_status ${CHECK_ADDR})

    # Log the current status
    msg_out "${CHECK_ADDR} : ${current_status}"

    # Has the verification status changed from what we last knew it as?
    if [ "$current_status" != "$LEAVE_STATUS" ]
    then
        # If running in a GUI environment, use notify-send to show a popup
        [ -n "$DISPLAY" ] && notify-send \
            -t 0 \
            "SES: ${CHECK_ADDR}" \
            "Current status: ${current_status}"

        # Exit the infinite loop
        break
    fi
    
    sleep ${POLL_INTERVAL}
done

