#!/bin/bash

SCR_DIR=`readlink -f "$(dirname $0)/../"`;
INI_FILE="$SCR_DIR/service/config.ini"
. $SCR_DIR/service/ini

BTIME=$(date -d '08:55:00' +%s)
ETIME=$(date -d '18:30:00' +%s)
CTIME=$(date +%s)
CDAYOFWEEK=$(date +%u)

TARGET_DIR=$(get_ini_section_param $INI_FILE Global ramdisk)
ROOT_DIR=$(get_ini_section_param $INI_FILE Global rootdir)




function logmsg
{
    [[ -n "$1" ]] && logger -t "scrennshots" -i -p user.info "$1";
}


function make_video
{ 
    FEED=$1
    FORMAT="mp4"
    FPS=$(get_ini_section_param $INI_FILE $FEED fps)
    FEED_DIR="$TARGET_DIR/$FEED"
    QUERY="$FEED_DIR/snap"
    LOCK_FILE=$TARGET_DIR/lock/$FEED
    QUERY_LIST=$(find $QUERY -type f -size +0)
    if [[ ( -d $QUERY ) && ( -n $QUERY_LIST ) && ( $(printf '%s\n' $QUERY_LIST | wc -l) -gt 1 ) ]]; then
        EVENT_DATE_STR='1970-01-01 '`stat --printf='%Y' $FEED_DIR`' sec GMT'
	EVENT_START_DATE=$(date -d "$EVENT_DATE_STR" +%Y%m%d)
	EVENT_START_TIME=$(date -d "$EVENT_DATE_STR" +%H%M%S)
	EVENT_END_DATE=$(date +%Y%m%d)
	EVENT_END_TIME=$(date +%H%M%S)
	#DIFF_SEC=`echo "$(date +%s) - $(date -d "$EVENT_START_DATE $EVENT_START_TIME" +%s)" | bc`
	DEST="$ROOT_DIR/$EVENT_START_DATE/$FEED/movie/$EVENT_START_TIME-$EVENT_END_TIME.$FORMAT"
	mkdir -p `dirname $DEST`
	logmsg "kmotion snapshots: make $FORMAT \"$DEST\""
	
	cat $QUERY/*.jpg | avconv -f image2pipe -r 2 -c:v mjpeg -i - -c:v libx264 -preset ultrafast -profile:v baseline -b:v 100k -qp 28 -an -r 25 $DEST &> /dev/null
	
	[[ $? -eq 0 ]] && logmsg "kmotion snapshots: $FORMAT \"$DEST\" SUCCESS" || logmsg "kmotion snapshots: $FORMAT \"$DEST\" FAIL"
	
	[[ ! -s $DEST ]] && rm -f $DEST
	#fi
	rm -rf $FEED_DIR
	
    fi
}

if [[ -z $1 ]]; then
    for f in `ls $TARGET_DIR`; do
	make_video $f;
    done;
else
    make_video $1;
fi






