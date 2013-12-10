#!/bin/bash

certainFile=${1:-./}

webhosts=(www1 www2)
#webhosts=(www1 www2 www3)

for webhost in ${webhosts[*]}; do
	printTitle.sh "Updating $webhost"
	ssh -t $webhost " cd /var/www/admin && sudo svn merge --dry-run -r BASE:HEAD ${certainFile} && echo && echo -n \"Do you want to svn up? \" && read line && [ \"\${line:0:1}\" == \"y\" ] && sudo svn up ${certainFile} || echo Cowardly refusing to update"
done

