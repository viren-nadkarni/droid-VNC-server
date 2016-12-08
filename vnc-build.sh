#!/usr/bin/env bash
set -x

# $ vnc-build -a [18|19]

DAEMON_BUILD_PATH=libs/armeabi-v7a
LIB_BUILD_PATH=nativeMethods/libs/armeabi-v7a
PUSH_PATH=/sdcard/vnc/files
DEPLOY_PATH=/data/local/tmp
CWD=$(pwd)

android=19
usage="usage: $0 [-a N] -w -s"

clean() {
    if [ -n "$do_build_wrapper" ]; then
        rm ${LIB_BUILD_PATH}/libdvnc_flinger_sdk${android}.so
    fi
    rm ${DAEMON_BUILD_PATH}/*
}

build_wrapper() {
    cd ../aosp
    . build/envsetup.sh
    cd external/nativeMethods
    mm .
    cd ${CWD}
}

while getopts ":a:w" opt; do
    case $opt in
        a  ) android=$OPTARG ;;
        w  ) do_build_wrapper='yep' ;;
        \? ) echo $usage
           exit 1 ;;
    esac
done

clean
ndk-build

if [ -n "$do_build_wrapper" ]; then
    build_wrapper
fi
