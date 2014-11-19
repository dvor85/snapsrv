#!/bin/bash

[[ -n "$1" ]] && FILE_NAME=$1 || exit;
if [[ ! -s $FILE_NAME ]]; then
    rm -f $FILE_NAME;
    exit;
fi;
FILE_DIR=`dirname $FILE_NAME`
LAST_LINK="$FILE_DIR/last.jpg"
PHASH=`$SCR_DIR/service/image_diff.php $FILE_NAME $LAST_LINK`

#cmp $FILE_NAME $LAST_LINK &>/dev/null
#if [[ $? -eq 0 ]]; then
if [[ $PHASH -gt 99 ]]; then
    rm -f $FILE_NAME;
else
    ln -sf $FILE_NAME $LAST_LINK
fi
