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


#remove file if staged file is marked for deletion
for fileToDelete in $(git diff --cached --name-status | grep ^D | cut -f2)
do
    if [ -e $fileToDelete ] #file exists
    then
        rm "$NICE_DIFF_FOLDER/$fileToDelete"
    fi
done

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
cd $NICE_DIFF_FOLDER
git add .
cd $WORKING_DIRECTORY