#!/bin/bash
performance_icon="%{F#f00}󰓅%{F-}"
schedutil_icon="󰾅"
powersave_icon="%{F#0f0}󰾆%{F-}"

function get_governor() {
    echo $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
}

function set_governor() {
    echo $1 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
}

function get_governor_icon() {
    governor_icon=${1}_icon
    if [ ${!governor_icon} ]; then
        echo ${!governor_icon}
    else
        echo "%{T1}$1%{T-}"
    fi
}

function get_list_idx() {
    list=("${@:2}")
    for i in "${!list[@]}"; do
        if [ "${list[$i]}" == "$1" ]; then
            echo "${i}"
            break
        fi
    done
}

function get_new_governor() {
    governors_roll=(powersave userspace conservative ondemand schedutil performance)
    available_govs=($(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors))
    idx=$(get_list_idx $cur_governor ${governors_roll[@]})
    size=${#governors_roll[@]}

    
    if [ "$1" == "--next" ]; then
        end=$((idx+size-1))
        range=$(seq $((idx+1)) $end)
    else
        end=$((idx-size+1))
        range=$(seq $(($idx-1)) -1 $end)
    fi

    for i in $range; do
        curr=$(($i % $size))
        if [[ "${available_govs[@]}" =~ "${governors_roll[$curr]}" ]]; then
            echo "${governors_roll[$curr]}"
            break
        fi
    done
}

cur_governor=$(get_governor)

case $1 in
    --rollr)
        set_governor $(get_new_governor --next)
        polybar-msg -p $2 hook governor 1
        ;;
    --rolll)
        set_governor $(get_new_governor --prev)
        polybar-msg -p $2 hook governor 1
        ;;
    --test)
        echo $(get_new_governor $2)
        ;;
    *)
        echo $(get_governor_icon $cur_governor)
        ;;
esac

