#!/bin/bash

[[ $UID -ne 0 ]] && echo "Must be run as root" 1>&2 && exit 1

time ( sudo swapoff /dev/sda2 ) ; time ( sudo swapon /dev/sda2 )
