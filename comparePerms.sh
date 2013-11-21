#!/bin/bash

getRealPath ()
{
	readlink -m $*
}

getOctalPerm ()
{
	local thisPath=$*
	stat -c "%a" "${thisPath}"
}

getOwner ()
{
	local thisPath=$*
	stat -c "%u" "${thisPath}"
}

getGroup ()
{
	local thisPath=$*
	stat -c "%g" "${thisPath}"
}

dir1=$(getRealPath "$1")
dir2=$(getRealPath "$2")

echo "Comparing permissions between:"
echo "'${dir1}'"
echo " AND"
echo "'${dir2}'"

getOctalPerm $dir1
getOwner $dir1
getGroup $dir1

i=0
find $dir1 | egrep -v "/\.svn(/|$)" | while read thisItem; do
	basePath=${thisItem:${#dir1}}
	otherItem="${dir2}${basePath}"

	if [ -e "${otherItem}" ]; then
		matchPerm=1
		matchOwner=1
		matchGroup=1

		[ $(getOctalPerm "${thisItem}") != $(getOctalPerm "${otherItem}") ] && matchPerm=0
		[ $(getOwner "${thisItem}") != $(getOwner "${otherItem}") ] && matchOwner=0
		[ $(getGroup "${thisItem}") != $(getGroup "${otherItem}") ] && matchGroup=0

		echo -e "${matchPerm}${matchOwner}${matchGroup}\t'${thisItem}'"
	fi
done
