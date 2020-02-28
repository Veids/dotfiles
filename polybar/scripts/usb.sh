#!/bin/bash
# Orig. Author: https://github.com/polybar/polybar-scripts

usb_print() {
    devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR)
    output=""
    counter=0

    for unmounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
        unmounted=$(echo "$unmounted" | tr -d "[:digit:]")
        unmounted=$(echo "$devices" | jq -r '.blockdevices[] | select(.name == "'"$unmounted"'") | .vendor')
        unmounted=$(echo "$unmounted" | tr -d ' ')

        if [ $counter -eq 0 ]; then
            space=""
        else
            space="   "
        fi
        counter=$((counter + 1))

        output="$output$space禍 $unmounted"
    done

    for mounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .size'); do
        if [ $counter -eq 0 ]; then
            space=""
        else
            space="   "
        fi
        counter=$((counter + 1))

        output="$output$space $mounted"
    done

    #MTP Devices
    mounted=""
    unmounted=""
    counter_mounted=0
    counter_umounted=0

    while read line; do
        device=$(echo "$line" | awk '{printf "/dev/bus/usb/%03d/%03d\n", $2,$4 }' | xargs -I{} udevadm info --name={})
        [ "$(echo "$device" | grep libmtp)" == "" ] && continue

        model=$(printf "$device" | awk -F= '/ID_MODEL=/ {gsub("_"," ");print $2}')
        serial=$(printf "$device" | awk -F= '/ID_SERIAL=/ {print $2}' )
        if [ "$(gio info mtp://$serial 2>/dev/null)" != "" ]; then
            [ -z $counter_mounted ] && space="" || space="   "

            mounted="$mounted$space $model"
            counter_mounted=$((counter_mounted + 1))
        else
            [ -z $counter_unmounted ] && space="" || space="   "

            pause="%{A1:playerctl -p $PLAYER play-pause:} %{A}"
            unmounted="$unmounted$space禍 $model"
            counter_unmounted=$((counter_unmounted + 1))
        fi
    done < <(lsusb)
    echo "$output $mounted $unmounted"
}

usb_update() {
    pid=$(/usr/bin/cat "$path_pid")

    if [ "$pid" != "" ]; then
        kill -10 "$pid"
    fi
    exit 0
}

path_pid="/tmp/polybar-system-usb-udev.pid"

case "$1" in
    --update)
        usb_update
        ;;
    --mount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)

        for mount in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
            udisksctl mount --no-user-interaction -b "$mount"
        done

        while read line; do
            device=$(echo "$line" | awk '{printf "/dev/bus/usb/%03d/%03d\n", $2,$4 }' | xargs -I{} udevadm info --name={})
            [ "$(echo "$device" | grep libmtp)" == "" ] && continue

            serial=$(printf "$device" | awk -F= '/ID_SERIAL=/ {print $2}' )
            if [ "$(gio info mtp://$serial 2>/dev/null)" == "" ]; then
                gio mount mtp://$serial
            fi
        done < <(lsusb)

        usb_update
        ;;
    --unmount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)

        for unmount in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .name'); do
            udisksctl unmount --no-user-interaction -b "$unmount"
            udisksctl power-off --no-user-interaction -b "$unmount"
        done

        while read line; do
            device=$(echo "$line" | awk '{printf "/dev/bus/usb/%03d/%03d\n", $2,$4 }' | xargs -I{} udevadm info --name={})
            [ "$(echo "$device" | grep libmtp)" == "" ] && continue

            serial=$(printf "$device" | awk -F= '/ID_SERIAL=/ {print $2}' )
            if [ "$(gio info mtp://$serial 2>/dev/null)" != "" ]; then
                gio mount -u mtp://$serial
            fi
        done < <(lsusb)

        usb_update
        ;;
    *)
        echo $$ > $path_pid

        trap exit INT
        trap "echo" USR1

        while true; do
            usb_print

            sleep 60 &
            wait
        done
        ;;
esac
