#!/bin/bash

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
        notify-send "Bluetoothctl" "Scanning for bluetooth devices"
        bluetoothctl power on
        timeout -sHUP 15s bluetoothctl scan on
        active="$(cur_connected)"
        mapfile -t list < <(bluetoothctl devices | awk '{print $3" "$2}')
        if [ -n "$active" ]; then
            status="   Connected"
            status_style="#prompt { background-color: @on; }"
            special="-a 0 -selected-row 1"
            # Variable passed to rofi
            for i in "${!list[@]}"; do
                if [[ "${list[i]}" =~ "$active" ]]; then
                    [ -n options ] && options="${list[i]}" || options="${list[i]}\n$options"
                    unset "list[i]"
                else 
                    options+="\n${list[i]}"
                fi
            done
        else
            status="   Disconnected"
            status_style="#prompt { background-color: @off; }"
            special=""
            # Variable passed to rofi
            options=""
            for i in "${!list[@]}"; do
                options+="${list[i]}\n"
            done
            options=${options::-2}
        fi
        chosen=$(echo -e "$options" | rofi -theme ~/.dotfiles/polybar/themes/nmvpnmenu.rasi -theme-str "$status_style" -p "$status" -dmenu -i $special)
        if [ "$chosen" == "" ]; then
            :
        elif [ "$active" != "" ]  && [[ "$chosen" =~ "$active" ]]; then
            # Disconnect the active vpn
            bluetoothctl disconnect
        else
            chosen=($chosen)
            if [ -n "$active" ]; then
                bluetoothctl disconnect
                wait
                sleep 1
            fi

            bluetoothctl connect "${chosen[1]}"
        fi
    ;;
    *)
    ;;
esac
