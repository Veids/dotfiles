#!/bin/sh

active="$(nmcli -g name,type con show --active | egrep '(vpn|wireguard)' | awk -F: '{print $1}')"
if [ $active ]; then
    echo " $active"
else
    echo "%{F#f24444}%{F-}"
fi
