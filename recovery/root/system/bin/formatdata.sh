#!/system/bin/sh

SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
    echo "I:$(date +'%H:%M:%S') [$SCRIPT_NAME] $@" >> /tmp/recovery.log
}

LOGMSG "---$SCRIPT_NAME start---"

MARKER="/persist/Fox/.format_cleanup_marker"

mkdir -p /persist/Fox
touch "$MARKER"

LOGMSG "Post-format cleanup marker set"

LOGMSG "---$SCRIPT_NAME end---"
