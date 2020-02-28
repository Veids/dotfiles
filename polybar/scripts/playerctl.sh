#!/bin/sh

# Use most recent player with playerctl
PLAYER=playerctld
player_status=$(playerctl -p $PLAYER status 2> /dev/null)
previous="%{A1:playerctl -p $PLAYER previous:} %{A}"
pause="%{A1:playerctl -p $PLAYER play-pause:} %{A}"
play="%{A1:playerctl -p $PLAYER play-pause:} %{A}"
next="%{A1:playerctl -p $PLAYER next:} %{A}"
metadata_info=$(playerctl -p $PLAYER metadata -f '{{artist}} - {{title}}' 2> /dev/null)

# DeaDBeeF has higher priority then other
if [ "$player_status" = "Playing" ]; then
    if [ "$metadata_info" = " - " ]; then
        echo "$previous $pause $next $(playerctl -p $PLAYER metadata xesam:url | xargs -I{} basename {} .mp3)"
    else
        echo "$previous $pause $next $metadata_info"
    fi
elif [ "$player_status" = "Paused" ]; then
    if [ "$metadata_info" = " - " ]; then
        echo "$previous $play $next $(playerctl -p $PLAYER metadata xesam:url | xargs -I{} basename {} .mp3)"
    else
        echo "$previous $play $next $metadata_info"
    fi
else
    echo ""
fi
