#!/bin/bash

SELF_NAME=$(basename $0) 
[[ $(id -u) -eq 0 ]] && echo -e "\n$SELF_NAME cant be run as root\n" && exit 0

export SCR_DIR=`readlink -f "$(dirname $0)/../"`;
cd $SCR_DIR
export INI_FILE="$SCR_DIR/service/config.ini"
. $SCR_DIR/service/ini

export target_dir=$(get_ini_section_param $INI_FILE Global ramdisk)
export feeds=$(get_ini_section_param $INI_FILE Global feeds)

function make_snapshot 
{
    FEED=$1
    snapshot_interval=$(get_ini_section_param $INI_FILE $FEED snapshot_interval)
    netcam_urls=$(get_ini_section_param $INI_FILE $FEED netcam_url)
    netcam_userpass=$(get_ini_section_param $INI_FILE $FEED netcam_userpass)
    snapshot_filename=$(get_ini_section_param $INI_FILE $FEED snapshot_filename)
    USERPASSWD=`echo $netcam_userpass | sed -r 's/^(.*):(.*)$/--user=\1 --password=\2/'`
    on_picture_save=$(get_ini_section_param $INI_FILE $FEED on_picture_save)
    curnetcam_url=${netcam_urls[0]};
    while true; do
	t1=$(date +%s.%N)
	filename=$target_dir/$FEED/$(date +"$snapshot_filename").jpg;
	mkdir -p `dirname $filename`
	
	wget -q -t 1 --timeout=$snapshot_interval -nc $USERPASSWD -O $filename $curnetcam_url &> /dev/null;
	if [[ $? -eq 0 ]]; then
	    test -n $on_picture_save && $on_picture_save $filename;
	else
	    rm -f $filename;
	    for netcam_url in $netcam_urls; do
		if [[ "$netcam_url" != "$curnetcam_url" ]]; then
		    wget -q -t 1 --timeout=$snapshot_interval -nc $USERPASSWD -O $filename $netcam_url &> /dev/null;
		    if [[ $? -eq 0 ]]; then
			test -n $on_picture_save && $on_picture_save $filename;
			curnetcam_url=$netcam_url;
		    else
			rm -f $filename;
		    fi;
		fi;
	    done;
	fi
	
	t2=$(date +%s.%N)
	dt=$(echo "$t2-$t1" | bc);
	sleep `echo "if ($snapshot_interval > $dt) { print $snapshot_interval-$dt } else { print 0 }" | bc`
	#sleep $(echo "$snapshot_interval-$dt" | bc);
    done;
}

for pid in $(pgrep -f "^\/.*\/$SELF_NAME" | sed "/$$/d"); do
    [[ -d /proc/$pid ]] && prevpid="$prevpid $pid"
done;
case "$1" in
    "start" | "restart" | "")
	if [[ $prevpid ]]; then
	    echo "$SELF_NAME already running"
	    echo "stopping..."
    	    kill -9 $prevpid
    	fi
        echo "starting...";        
        for feed in $feeds; do
	    make_snapshot $feed &
	done;	
	;;
    "stop")
	if [[ $prevpid ]]; then
	    echo "stopping..."
    	    kill -9 $prevpid
    	else
	    echo "not running...";
	fi
	;;
    *)
	echo "uses $SELF_NAME [start|restart|stop]";
	;;    
esac
