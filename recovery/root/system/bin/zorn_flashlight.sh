#!/system/bin/sh

DIR="/tmp/flashlight"
STATE_FILE="$DIR/brightness"
MAX_FILE="$DIR/max_brightness"

SWITCH_0="/sys/class/leds/led:switch_0/brightness"
SWITCH_1="/sys/class/leds/led:switch_1/brightness"
TORCH_0="/sys/class/leds/led:torch_0/brightness"
TORCH_1="/sys/class/leds/led:torch_1/brightness"

LAST=""

write_if_present() {
    node="$1"
    value="$2"
    [ -e "$node" ] && echo "$value" > "$node"
}

set_flashlight() {
    case "$1" in
        1)
            write_if_present "$TORCH_0" 40
            write_if_present "$TORCH_1" 40
            write_if_present "$SWITCH_0" 1
            write_if_present "$SWITCH_1" 1
            ;;
        *)
            write_if_present "$SWITCH_0" 0
            write_if_present "$SWITCH_1" 0
            write_if_present "$TORCH_0" 0
            write_if_present "$TORCH_1" 0
            ;;
    esac
}

rm -rf "$DIR"
mkdir -p "$DIR"

echo 1 > "$MAX_FILE"
echo 0 > "$STATE_FILE"
chmod 666 "$MAX_FILE" "$STATE_FILE"

set_flashlight 0

while true; do
    STATE=""
    IFS= read -r STATE < "$STATE_FILE"

    case "$STATE" in
        1|[1-9]*)
            if [ "$LAST" != "1" ]; then
                set_flashlight 1
                LAST="1"
            fi
            ;;
        *)
            if [ "$LAST" != "0" ]; then
                set_flashlight 0
                LAST="0"
            fi
            ;;
    esac

    sleep 0.1
done
