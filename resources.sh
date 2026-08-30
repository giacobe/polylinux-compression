#!/bin/sh

die() {
    echo "ERROR: $*" >&2
    exit 1
}

command_required() {
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

derive_hex() {
    label=$1
    printf '%s:%s' "$level_HASH" "$label" | sha256sum | awk '{print $1}'
}

hex_byte() {
    hex=$1
    index=$2
    start=$((index * 2 + 1))
    pair=$(printf '%s' "$hex" | cut -c "$start-$((start + 1))")
    printf '%d\n' "$((0x$pair))"
}

range_from_byte() {
    byte=$1
    minimum=$2
    maximum=$3
    printf '%d\n' "$((minimum + byte % (maximum - minimum + 1)))"
}

base64url_digest() {
    printf '%s' "$1" | xxd -r -p | base64 | tr -d '\r\n=' | tr '+/' '-_'
}

answer_token() {
    length=$1
    answer_hex=$(derive_hex answer)
    base64url_digest "$answer_hex" | cut -c "1-$length"
}

pick_from_words() {
    words=$1
    byte=$2
    set -- $words
    count=$#
    wanted=$((byte % count + 1))
    eval "printf '%s\\n' \"\${$wanted}\""
}

deterministic_timestamp() {
    layout_hex=$(derive_hex layout)
    day=$(range_from_byte "$(hex_byte "$layout_hex" 8)" 1 28)
    hour=$(range_from_byte "$(hex_byte "$layout_hex" 9)" 0 23)
    minute=$(range_from_byte "$(hex_byte "$layout_hex" 10)" 0 59)
    printf '202406%02d%02d%02d\n' "$day" "$hour" "$minute"
}

write_readme() {
    instructions=$1
    {
        echo "* Create date: $currentDate"
        echo "* User       : $USER_ID"
        echo "************************************************************************"
        echo "* Instructions for this level"
        echo "************************************************************************"
        printf '%s\n' "$instructions"
    } > "$LEVEL_HOME/README.txt"
}

finish_level() {
    chown -R "$levelToBuild:$levelToBuild" "$LEVEL_HOME"
    chmod -R o-rwx "$LEVEL_HOME"
}

fresh_workdir() {
    work="/tmp/compression-bandit-$levelToBuild"
    rm -rf "$work"
    mkdir -p "$work"
    printf '%s\n' "$work"
}

cleanup_workdir() {
    case "$1" in
        /tmp/compression-bandit-level*) rm -rf "$1" ;;
        *) die "refusing to remove unexpected work directory: $1" ;;
    esac
}

