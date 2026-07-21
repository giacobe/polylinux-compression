#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer_hex=$(derive_hex answer)
phrase_index=$(hex_byte "$answer_hex" 0)
phrase_index=$((phrase_index % 16))
answer=$(sed -n "$((phrase_index + 1))p" "$INSTALL_ROOT/phrases.txt")
layout_hex=$(derive_hex layout)
layout_byte0=$(hex_byte "$layout_hex" 0)
layout_byte1=$(hex_byte "$layout_hex" 1)
document=$((1 + layout_byte0 % 8))
project=$((300 + (layout_byte1 * 7 + document) % 700))
work=$(fresh_workdir)
mkdir -p "$work/bundle/documents"

i=1
while [ "$i" -le 8 ]; do
    if [ "$i" -eq "$document" ]; then
        phrase=$answer
        code=$project
    else
        phrase=$(sed -n "$(((phrase_index + i) % 16 + 1))p" "$INSTALL_ROOT/phrases.txt")
        code=$((300 + (project + i * 41) % 700))
    fi
    {
        echo "Project: PRJ-$code"
        echo "Approval phrase: $phrase"
        echo "Status: archived"
    } > "$work/bundle/documents/record-$i.txt"
    i=$((i + 1))
done
{
    echo "The authoritative record is project PRJ-$project."
    echo "Submit its approval phrase."
} > "$work/bundle/CATALOG.txt"
(cd "$work/bundle" && zip -qr "$LEVEL_HOME/project-records.zip" CATALOG.txt documents)

write_readme "Inspect and extract project-records.zip. Follow CATALOG.txt and submit the authoritative project's approval phrase, including its space."
record_answer "$answer"
cleanup_workdir "$work"
finish_level
