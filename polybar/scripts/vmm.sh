#!/bin/bash
# Simple script that queries 'lxc ls' and 'virsh list' commands

lxc_icon=
libvirt_icon=ﲾ
docker_icon=󰡨

function process_list() {
    list=("${@:2}")
    if [ $list ]; then
        info=""
        for i in "${!list[@]}"; do
            info+="$1 ${list[i]} "
        done
        echo ${info::-1}
    fi
}

# lxc/lxd info
function get_lxc() {
    mapfile -t active_list < <(sudo lxc ls --format csv -c n,s 2>/dev/null | grep RUNNING | awk -F, '{print $1}')
    process_list $lxc_icon "${active_list[@]}"
}

# libvirt info includes some vagrant machines using libvirt provider
function get_libvirt() {
    mapfile -t active_list < <(sudo virsh list --name 2>/dev/null)
    process_list $libvirt_icon "${active_list[@]}"
}

# docker info (just container id)
function get_docker() {
    mapfile -t active_list < <(sudo docker ps -q)
    process_list $docker_icon "${active_list[@]}"
}

echo $(get_lxc) $(get_libvirt) $(get_docker)
