#!/bin/sh

### BEGIN INIT INFO
# Provides:          screenshots
# Required-Start:    $network $local_fs $remote_fs $syslog
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: 
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
screenshots=/usr/local/screenshots/service/grab.sh

case "$1" in
start)
    sudo -u videouser $screenshots &> /dev/null
    ;;
stop)
    sudo -u videouser $screenshots stop
    ;;
*)
    echo "Usage: <start|stop>"
    ;;
esac

exit 0
