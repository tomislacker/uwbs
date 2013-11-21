#!/bin/bash

find ./ -type f -iname "*.php" | sort | while read thisPHPFile; do
	php -l "${thisPHPFile}" >>/dev/null && \
		echo -en "\033[01;32m[ Pass ]" || \
		echo -en "\033[01;31m[ FAIL ]"
	echo -en "\033[0m"
	echo -e "\t${thisPHPFile}"
done

