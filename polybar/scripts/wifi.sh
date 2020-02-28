#!/bin/bash

disconnect() {
    nmcli con down id "$1" && notify-send "Network Manager" "Disconnected from <b>$1</b>" || notify-send "Network Manager" "Error disconnecting from <b>$1</b>!"
}

connect() {
    nmcli con up id "$1" && notify-send "Network Manager" "Now connected to <b>$1</b>" || notify-send "Network Manager" "Error connecting to <b>$1</b>!"
}

connect_password() {
    if [[ "$(nmcli dev wifi connect "$1" password "$2")" == *" successfully"* ]]; then
        notify-send "Network Manager" "Now connected to <b>$1</b>"
    else
        notify-send "Network Manager" "Error connecting to <b>$1</b>!"
        nmcli con delete "$1"
    fi
}

notify-send "Network Manager" "Scanning wifi networks"
nmcli device wifi rescan 2>/dev/null
active="$(nmcli -g name,type con show --active | grep 'wireless' | awk -F: '{print $1}')"
mapfile -t predef < <(nmcli -g name,type con | grep 'wireless' | awk -F: '{print $1}')
mapfile -t list < <(nmcli -t -f SSID,CHAN,RATE,SECURITY device wifi)

if [ -n "$active" ]; then
    status="   Connected"
    status_style="#prompt { background-color: @on; }"
    special="-a 0 -selected-row 1"
    # Variable passed to rofi
    options="$active"
    for i in "${!list[@]}"; do
        [ "${list[i]}" == "$active" ] && unset "list[i]" || options+="\n${list[i]}"
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

chosen=$(echo -e "$options" | rofi -theme ~/.dotfiles/polybar/themes/nmvpnmenu.rasi -theme-str "$status_style" -p "$status" -dmenu -i $special | awk -F: '{print $1}')
if [ "$chosen" == "" ]; then
    :
elif [ "$chosen" == "$active" ]; then
    disconnect "$active"
else
    ispredef=0
    for i in "${!predef[@]}"; do
        [ "${predef[i]}" == "$chosen" ] && ispredef=1 && break
    done
    if [ "$ispredef" -eq 0 ]; then
        status_style="#prompt { background-color: @on; }"
        pass=$(rofi -dmenu -p "Choose password" -password -theme ~/.dotfiles/polybar/themes/nmvpnmenu.rasi -theme-str "$status_style")
        connect_password "$chosen" "$pass"
    else
        [ -n "$active" ] && disconnect "$active"
        connect "$chosen"
    fi
fi
