#!/bin/bash

DEFAULT_POLL_FREQ=1

pollFreq=${1:-${DEFAULT_POLL_FREQ}}

if ! which git >&/dev/null; then
	echo 'ERROR: Unable to find git in $PATH' >&2
	exit 1
elif ! which ccze >&/dev/null; then
	echo 'ERROR: Unable to find ccze in $PATH' >&2
	exit 2
fi

watch \
    --color \
    -t \
    -n ${pollFreq} \
    'echo ; ( git status ; echo ; git branch -a ) | ccze -A'

