#!/bin/sh
#
# This script sorts the reaper-kb.ini file.
# It adds the folder "niceDiff" if neccesary. In this folder
# all files are stored which are "beautified" for a human readable
# diff. This script also deletes "beautified" files if appropriate.

NICE_DIFF_FOLDER="niceDiff"
REAPER_KB_INI="reaper-kb.ini"
WORKING_DIRECTORY=$PWD
cd "$(git rev-parse --show-cdup)" #go to toplevel directory in this repository

# create folder "niceDiff" if it does not exist
[ ! -d "$NICE_DIFF_FOLDER" ] && mkdir -p "$NICE_DIFF_FOLDER"

# do something for staged file that is marked as modified
for modifiedFile in $(git diff --cached --name-status | grep ^M | cut -f2)
do
    if [ "$modifiedFile" == "$REAPER_KB_INI" ]
    then
        grep ^ACT $modifiedFile | uniq | sort  > "$NICE_DIFF_FOLDER/$modifiedFile"
        grep ^SCR $modifiedFile | uniq | sort >> "$NICE_DIFF_FOLDER/$modifiedFile"
        grep ^KEY $modifiedFile | uniq | sort >> "$NICE_DIFF_FOLDER/$modifiedFile"
    fi
done

# add nice diffed files to this commit and go back to previous working folder
git add $NICE_DIFF_FOLDER > /dev/null 2>&1
cd $WORKING_DIRECTORY