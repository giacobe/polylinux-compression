#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer_hex=$(derive_hex answer)
answer_byte0=$(hex_byte "$answer_hex" 0)
answer_byte1=$(hex_byte "$answer_hex" 1)
ticket=$((1000 + (answer_byte0 * 256 + answer_byte1) % 9000))
layout_hex=$(derive_hex layout)
layout_byte0=$(hex_byte "$layout_hex" 0)
target=$((5 + layout_byte0 % 15))
work=$(fresh_workdir)

echo "status ticket owner" > "$work/dispatch.tsv"
i=1
while [ "$i" -le 24 ]; do
    if [ "$i" -eq "$target" ]; then
        echo "DELIVERED $ticket compression-desk" >> "$work/dispatch.tsv"
    else
        noise_index=$((i % 16))
        noise_byte=$(hex_byte "$layout_hex" "$noise_index")
        noise=$((2000 + (i * 173 + noise_byte) % 7000))
        echo "ARCHIVED $noise queue-$i" >> "$work/dispatch.tsv"
    fi
    i=$((i + 1))
done
bzip2 -c "$work/dispatch.tsv" > "$LEVEL_HOME/dispatch.tsv.bz2"

write_readme "A bzip2-compressed dispatch table is in this directory. The answer is the ticket number owned by compression-desk."
record_answer "$ticket"
cleanup_workdir "$work"
finish_level
