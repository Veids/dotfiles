#!/bin/sh
path_pid="/tmp/polybar-airplane.pid"

case $1 in
    --trigger)
        nPid=$(/usr/bin/cat "$path_pid")
        if [ "$nPid" != "" ]; then
            kill -s INT $nPid
        fi
        exit 0
        ;;
    *)
        echo $$ > $path_pid
        trap exit INT
        trap "echo" USR1

        while true; do
            [[ $(rfkill -no soft | grep -w blocked | wc -l ) -eq 4 ]] && echo "" || echo ""
            sleep 120 &
            wait
        done
        ;;
esac
