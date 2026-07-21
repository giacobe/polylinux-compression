#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer="flag-$(answer_token 14)"
layout_hex=$(derive_hex layout)
layout_byte0=$(hex_byte "$layout_hex" 0)
target=$((4 + layout_byte0 % 12))
work=$(fresh_workdir)

i=1
while [ "$i" -le 20 ]; do
    if [ "$i" -eq "$target" ]; then
        echo "release-token: $answer" >> "$work/release-notes.txt"
    else
        echo "component-$i passed routine validation" >> "$work/release-notes.txt"
    fi
    i=$((i + 1))
done
xz -c "$work/release-notes.txt" > "$LEVEL_HOME/payload.bin"

write_readme "The file payload.bin has no useful extension. Identify its type with file, decompress it with the appropriate compression tool, and report the release-token."
record_answer "$answer"
cleanup_workdir "$work"
finish_level
