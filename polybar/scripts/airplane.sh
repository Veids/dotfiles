#!/bin/bash
if [ "$1" == "--update" ]; then
    polybar-msg -p $(pgrep -f "polybar top") hook airplane 1
else
    [[ $(rfkill -no soft | grep -w blocked | wc -l ) -eq 4 ]] && echo "󰀞" || echo ""
fi
