#!/bin/bash

DO_FORCE=no

while getopts "f" OPT
do
	case $OPT in
		h)
			showUsage
			exit 0
			;;
		f)
			DO_FORCE=yes
			;;
		?)
			echo "Invalid option -${OPTARG}" 1>&2
			exit 1
			;;
		\*)
			echo "Option -${OPTARG} requires argument" 1>&2
			exit 2
			;;
	esac
done

if [ "${DO_FORCE}" == "yes" ]; then
	find ./ -type d -name ".svn" | while read svnDir; do
		rm -fr "${svnDir}" >>/dev/null
	done
else
	echo "####################"
	echo "# About to Delete: #"
	echo "####################"
	find ./ -type d -name ".svn"
	echo

	echo -n "Continue? [N/y]: "
	read doContinue
	if [ "${doContinue}" != "y" ]; then
		echo "Aborting"
		exit 0
	fi

	find ./ -type d -name ".svn" | while read svnDir; do
		rm -fr "${svnDir}" >> /dev/null
	done
fi
	
