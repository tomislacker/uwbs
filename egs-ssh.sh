#!/bin/bash

HOSTNAME=$1
SCREEN_PREFIX=$(whoami)

# Trim off protocol handler (if any)
HOSTNAME=$(echo $HOSTNAME | sed 's/^[a-zA-Z]\{3,5\}:\/\///g' | sed 's/\/.*$//g')

# SSH in, su to root, and launch screen
ssh -t ${HOSTNAME} "su -c screen -- -S ${SCREEN_PREFIX}$(date +%s)" 
