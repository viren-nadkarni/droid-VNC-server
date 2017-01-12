#!/usr/bin/env bash
# $ vnc-build -a [16..25] -w

set -e

DAEMON_BUILD_PATH=libs/armeabi-v7a
LIB_BUILD_PATH=nativeMethods/libs/armeabi-v7a
CWD=$(pwd)

usage() {
    echo "Usage: $0 -w -a API_LEVEL"
}

clean() {
    if [ -n "$WRAPPER_LIB" ]; then
        rm ${LIB_BUILD_PATH}/libdvnc_flinger_sdk${API_LEVEL}.so || true
    fi
    rm ${DAEMON_BUILD_PATH}/* || true
}

build_wrapper() {
    cd ../aosp

    source build/envsetup.sh
    lunch aosp_arm-eng

    ls external/nativeMethods &> /dev/null || ln -s ${CWD}/nativeMethods external/nativeMethods
    mmma external/nativeMethods
    cd ${CWD}
}

while getopts ":a:w" o; do
    case $o in
        a)  API_LEVEL=$OPTARG ;;
        w)  WRAPPER_LIB='yes' ;;
        \?) usage
            exit 1 ;;
    esac
done

if [ -z "$API_LEVEL" ]; then
    echo "No API level specified"
    usage
    exit 1
fi

clean
ndk-build

if [ -n "$WRAPPER_LIB" ]; then
    build_wrapper
fi
