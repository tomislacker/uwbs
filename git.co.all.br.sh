#!/bin/bash

DO_FORCE=

branchList=( \
    $(git branch -a | grep remotes | grep -v HEAD | grep -v master) \
)

# If there are branches to merge...
if [[ ${#branchList[*]} -gt 0 ]]; then

    # List branches to be merged
    echo "NOTICE: Intending to merge locally:"
    for branch in ${branchList[*]}; do
        echo -e "NOTICE: \t${branch}"
    done
    
    # If we don't know to force, ask if desired
    if [ -z "$DO_FORCE" ]; then
        echo -n "QUESTION: Continue? [N/y]: "
        read line
        if [ "${line:0:1}" != 'y' -a "${line:0:1}" != 'Y' ]; then
            exit 1
        fi
    fi

    # Merge branches
    for branch in ${branchList[*]}; do
        git branch --track ${branch##*/} $branch
    done
else
    # There are no branches to merge
    echo "NOTICE: No branches to merge"
fi
