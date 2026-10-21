#!/system/bin/sh

MARKER="/persist/Fox/.format_cleanup_marker"

[ -f "$MARKER" ] || exit 0

mount /data 2>/dev/null

if ! grep -q " /data " /proc/mounts 2>/dev/null; then
    exit 0
fi

if [ -e /data/system/users/0.xml ]; then
    rm -f "$MARKER"
    exit 0
fi

umount /sdcard 2>/dev/null
umount -l /sdcard 2>/dev/null

[ -d /data/media ] && rm -rf /data/media
[ -d /data/local ] && rm -rf /data/local

rm -f "$MARKER"
sync
