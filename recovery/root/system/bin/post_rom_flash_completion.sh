#!/system/bin/sh

restore_recovery_slot() {
    slot="$1"

    for base in /dev/block/bootdevice/by-name /dev/block/by-name; do
        target="$base/recovery$slot"
        if [ -e "$target" ]; then
            if dd if=/tmp/fox_backup.img of="$target" bs=1M 2>/dev/null; then
                sync
                return 0
            fi
        fi
    done

    return 1
}

if [ -s /tmp/fox_backup.img ]; then
    for slot in _a _b; do
        restore_recovery_slot "$slot"
    done
fi
