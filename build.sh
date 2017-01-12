#!/usr/bin/env bash

set -eux

# $ vnc-build -a [16..25] -w

DAEMON_BUILD_PATH=libs/armeabi-v7a
LIB_BUILD_PATH=nativeMethods/libs/armeabi-v7a
CWD=$(pwd)

SDK_LEVEL=23
USAGE="Usage: $0 [-a SDK_LEVEL] -w"

clean() {
    if [ -n "$do_build_wrapper" ]; then
        rm ${LIB_BUILD_PATH}/libdvnc_flinger_sdk${SDK_LEVEL}.so || true
    fi
    rm ${DAEMON_BUILD_PATH}/* || true
}

build_wrapper() {
    cd ../aosp

    set +eu
    source build/envsetup.sh
    set -eu

    # ln
    mmma external/nativeMethods
    cd ${CWD}
}

while getopts ":a:w" opt; do
    case $opt in
        a)  SDK_LEVEL=$OPTARG ;;
        w)  do_build_wrapper='yes' ;;
        \?) echo $usage
            exit 1 ;;
    esac
done

echo "Building for SDK ${SDK_LEVEL}"
clean
ndk-build

if [ -n "$do_build_wrapper" ]; then
    build_wrapper
fi
