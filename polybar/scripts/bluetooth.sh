#!/bin/sh
case "$1" in
    --status)
        if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
            echo ""
        else
            if [ $(bluetoothctl info | grep "Device" | wc -c) -eq 0 ]; then
                echo ""
            else
                echo ""
            fi
        fi
    ;;
    --toggle)
        if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
        then
            bluetoothctl power on
        else
            playerctl -a pause && sleep 0.1
            bluetoothctl power off
        fi
    ;;
    --menu)
    ;;
    *)
    ;;
esac
