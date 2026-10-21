#!/system/bin/sh

if grep -q " /firmware " /proc/mounts 2>/dev/null; then
    umount /firmware 2>/dev/null
fi

if grep -q " /vendor/firmware_mnt " /proc/mounts 2>/dev/null; then
    stop vendor.ssgtzd
    umount /vendor/firmware_mnt 2>/dev/null
fi

resetprop ro.build.version.security_patch 2024-09-01

if ! grep -q " /metadata " /proc/mounts 2>/dev/null; then
    mount /metadata 2>/dev/null
fi

slot="$(getprop ro.boot.slot_suffix)"

case "$slot" in
    _a|_b)
        free_tmp="$(df /tmp 2>/dev/null | tail -n 1 | awk '{print $4}')"
        if [ -z "$free_tmp" ] || [ "$free_tmp" -ge 131072 ]; then
            for base in /dev/block/bootdevice/by-name /dev/block/by-name; do
                recovery_block="$base/recovery$slot"
                if [ -e "$recovery_block" ]; then
                    if dd if="$recovery_block" of=/tmp/fox_backup.img bs=1M 2>/dev/null; then
                        sync
                    else
                        rm -f /tmp/fox_backup.img
                    fi
                    break
                fi
            done
        fi
        ;;
esac
