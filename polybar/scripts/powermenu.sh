#!/bin/bash

rofi_command="rofi -theme ~/.dotfiles/polybar/themes/powermenu.rasi"

### Options ###
power_off=""
reboot=""
lock=""
suspend="鈴"
log_out=""
# Variable passed to rofi
options="$power_off\n$reboot\n$lock\n$suspend\n$log_out"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    $power_off)
        ~/.dotfiles/polybar/scripts/promptmenu.sh --yes-command "systemctl poweroff" --query "Shutdown?"
        ;;
    $reboot)
        ~/.dotfiles/polybar/scripts/promptmenu.sh --yes-command "systemctl reboot" --query "Reboot?"
        ;;
    $lock)
        qdbus org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.MainWindow.lockAllDatabases 2> /dev/null
        i3lock-fancy
        ;;
    $suspend)
        mpc -q pause
        playectl -a pause
        amixer set Master mute
        qdbus org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.MainWindow.lockAllDatabases 2> /dev/null
        i3lock-fancy
        systemctl suspend
        ;;
    $log_out)
        i3-msg exit
        ;;
esac

