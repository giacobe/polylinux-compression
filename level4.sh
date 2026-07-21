#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer_hex=$(derive_hex answer)
list_index=$(hex_byte "$answer_hex" 0)
list_index=$((list_index % 16))
word_index=$(hex_byte "$answer_hex" 1)
word_index=$((word_index % 16))
answer=$(sed -n "$((list_index + 1))p" "$INSTALL_ROOT/wordgrid.txt" | awk -v n="$((word_index + 1))" '{print $n}')
work=$(fresh_workdir)
mkdir -p "$work/archive/reports"

i=0
while [ "$i" -lt 16 ]; do
    sed -n "$((i + 1))p" "$INSTALL_ROOT/wordgrid.txt" > "$work/archive/reports/list-$(printf '%02d' "$i").txt"
    i=$((i + 1))
done
{
    echo "Archive retrieval ticket"
    echo "List: $list_index"
    echo "Entry: $word_index"
    echo "Numbering starts at zero. Words are separated by spaces."
} > "$work/archive/INDEX.txt"
(cd "$work/archive" && tar -cf "$LEVEL_HOME/records.tar" INDEX.txt reports)

write_readme "records.tar is an uncompressed archive. List or extract it, follow INDEX.txt, and submit the selected word."
record_answer "$answer"
cleanup_workdir "$work"
finish_level
