# droid-vnc-server

VNC server for Android, tested working with Jelly Bean till Marshmallow

## Getting started

Make sure Android SDK and NDK are installed

    bash build.sh -wa API_LEVEL

Specify API level with `-a`

Use `-w` flag to build the wrapper libs; AOSP source is required at `../aosp`

Wrapper libs for API 19 to 25 have been prebuilt in [](nativeMethods/libs/armeabi-v7a/) and should work out of the box
