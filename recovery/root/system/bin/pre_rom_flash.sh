#!/system/bin/sh

SCRIPT_NAME="$(basename "$0")"

LOGMSG() {
    echo "I:$(date +'%H:%M:%S') [$SCRIPT_NAME] $@" >> /tmp/recovery.log
}

LOGMSG "---$SCRIPT_NAME start---"

LOGMSG "Resetting SPL date to prevent anti-rollback protection..."
resetprop ro.build.version.security_patch 2024-09-01

D="/metadata/ota"

mount /metadata 2>/dev/null

LOGMSG "Checking for stale OTA metadata which may block ROM install..."
if [ -d "$D" ]; then
    LOGMSG "Wiping $D..."
    rm -rf "$D" 2>/dev/null
fi

LOGMSG "Detecting active boot slot..."
slot="$(getprop ro.boot.slot_suffix)"
if [ -z "$slot" ]; then
    LOGMSG "Unable to detect active boot slot; skipping recovery backup..."
else
    LOGMSG "Active boot slot: $slot"

    # Check for free space in /tmp (need at least 128MB to be safe)
    FREE_TMP=$(df /tmp | tail -n 1 | awk '{print $4}')
    if [ "$FREE_TMP" -lt 131072 ]; then
        LOGMSG "Insufficient space in /tmp ($FREE_TMP MB); skipping recovery backup..."
    else
        LOGMSG "Backing up OrangeFox recovery before ROM overwrites..."
        if [ -e /dev/block/bootdevice/by-name/recovery${slot} ]; then
            if dd if="/dev/block/bootdevice/by-name/recovery${slot}" of="/tmp/fox_backup.img" bs=1M; then
                sync
                LOGMSG "Backup of OrangeFox recovery was successful"
            else
                LOGMSG "Failed to backup OrangeFox recovery..."
            fi
        else
            LOGMSG "Recovery partition not found; skipping backup..."
        fi
    fi
fi

LOGMSG "---$SCRIPT_NAME end---"
