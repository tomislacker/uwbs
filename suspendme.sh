#!/bin/bash

if zenity --question --text="Are you sure you want to suspend?"; then
    sudo systemctl stop openvpn@Etho
    /home/ben/.screenlayout/btomasik-novga.sh
	killall pidgin
	notify-send -t 3000 "Suspend" "Going down for suspend now..."
	sleep 
	sudo systemctl start systemd-suspend
else
	notify-send -t 5000 "Suspend" "NOT suspending..."
fi
