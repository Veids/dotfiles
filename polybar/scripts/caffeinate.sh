#!/bin/bash
socket_path="/tmp/xidlehook.sock"
timer_number=2

function get_timer_status() {
    xidlehook-client --socket $1 query --timer $2 | grep "disabled: true"
}

function control_timer() {
    xidlehook-client --socket $1 control --timer $2 --action $3
}

timer_disabled=$(get_timer_status $socket_path $timer_number)
if [ "$1" = "--status" ]; then
    [[ "$timer_disabled" ]] && echo 󰅶|| echo 󰾪
else
    set -x
    if [ "$timer_disabled" ]; then
        control_timer $socket_path $timer_number Enable
        polybar-msg -p $1 hook caffeinate 1
    else
        control_timer $socket_path $timer_number Disable
        polybar-msg -p $1 hook caffeinate 1
    fi
fi
