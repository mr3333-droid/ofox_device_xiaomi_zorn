#!/system/bin/sh

SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
    echo "I:$(date +'%H:%M:%S') [$SCRIPT_NAME] $@" >> /tmp/recovery.log
}

MARKER="/persist/Fox/.format_cleanup_marker"

[ -f "$MARKER" ] || exit 0

LOGMSG "---$SCRIPT_NAME start---"

LOGMSG "Checking if recovery is in a post-format data state..."

mount /data

if ! grep -q " /data " /proc/mounts; then
    LOGMSG "/data is not mounted so keeping the post-format cleanup marker in place..."
    LOGMSG "---$SCRIPT_NAME end---"
    exit 0
fi

if [ -e /data/system/users/0.xml ]; then
    LOGMSG "/data already seems initialised so removing the post-format cleanup marker..."
    rm -f "$MARKER"
    LOGMSG "---$SCRIPT_NAME end---"
    exit 0
fi

umount /sdcard
umount -l /sdcard

if [ -d /data/media ]; then
    LOGMSG "Cleaning up temporary /data/media bind-mounted to /sdcard for MTP..."
    rm -rf /data/media
fi

if [ -d /data/local ]; then
    LOGMSG "Cleaning up temporary /data/local created by KSU add-on..."
    rm -rf /data/local
fi

LOGMSG "Removing the post-format data marker..."
rm -f "$MARKER"
sync

LOGMSG "Post-format cleanup complete"
LOGMSG "This should prevent Android storage preparation / mount issues"

LOGMSG "---$SCRIPT_NAME end---"
