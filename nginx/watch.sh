#!/bin/bash
# Author: Devonte
# Watches a file or directory for changes and runs a command on change
# USAGE: sh watch.sh /path/to/dir command_to_run

watch() {
    dir="$1"
    checksum_initial=`tar -cf - $dir | md5sum | awk '{print $1}'`
    checksum_now=$checksum_initial

    while [ $checksum_initial = $checksum_now ]
    do
        sleep 3
        checksum_now=`tar -cf - $dir | md5sum | awk '{print $1}'`
    done

    eval $2 && watch $*
}

watch $*