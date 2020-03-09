#!/bin/bash
# Orig. Author: https://github.com/polybar/polybar-scripts

function mount_usb() {
    udisksctl mount --no-user-interaction -b "$1"
}

function unmount_usb() {
    udisksctl unmount --no-user-interaction -b "$1"
    udisksctl power-off --no-user-interaction -b "$1"
}

function usb_devices() {
    devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR)
    output=""
    counter=0

    for unmounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
        mpoint=$unmounted
        unmounted=$(echo "$unmounted" | tr -d "[:digit:]")
        unmounted=$(echo "$devices" | jq -r '.blockdevices[] | select(.name == "'"$unmounted"'") | .vendor')
        unmounted=$(echo "$unmounted" | tr -d ' ')

        [ -z $counter ] && space="" || space="   "

        output="$output$space%{A1:~/.dotfiles/polybar/scripts/usb.sh --musb $mpoint:}禍 $unmounted%{A}"
        counter=$((counter + 1))
    done

    for mounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .name'); do
        mpoint=$mounted
        mounted=$(echo "$mounted" | tr -d "[:digit:]")
        mounted=$(echo "$devices" | jq -r '.blockdevices[] | select(.name == "'"$mounted"'") | .vendor')
        mounted=$(echo "$mounted" | tr -d ' ')

        [ -z $counter ] && space="" || space="   "

        output="$output$space%{A1:~/.dotfiles/polybar/scripts/usb.sh --uusb $mpoint:} $mounted%{A}"
        counter=$((counter + 1))
    done
    echo $output
}

function mount_mtp() {
    gio mount mtp://"$1"
}

function unmount_mtp() {
    gio mount -u mtp://"$1"
}

function mtp_devices() {
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

            mounted="$mounted$space%{A1:~/.dotfiles/polybar/scripts/usb.sh --umtp $serial:}󰧕 $model%{A}"
            counter_mounted=$((counter_mounted + 1))
        else
            [ -z $counter_unmounted ] && space="" || space="   "

            unmounted="$unmounted$space%{A1:~/.dotfiles/polybar/scripts/usb.sh --mmtp $serial:}󰄝 $model%{A}"
            counter_unmounted=$((counter_unmounted + 1))
        fi
    done < <(lsusb)
    echo "$mounted $unmounted"
}

function polybar_ipc() {
    polybar-msg -p $(pgrep -f polybar\ top) hook usb 1
}

case "$1" in
    --musb)
        mount_usb $2
        polybar_ipc
        ;;
    --uusb)
        unmount_usb $2
        polybar_ipc
        ;;
    --mmtp)
        mount_mtp $2
        polybar_ipc
        ;;
    --umtp)
        unmount_mtp $2
        polybar_ipc
        ;;
    *)
        echo $(usb_devices) $(mtp_devices)
        ;;
esac
