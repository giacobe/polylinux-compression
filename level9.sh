#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer_hex=$(derive_hex answer)
answer_byte0=$(hex_byte "$answer_hex" 0)
answer_byte1=$(hex_byte "$answer_hex" 1)
answer=$((10000 + (answer_byte0 * 256 + answer_byte1) % 90000))
layout_hex=$(derive_hex layout)
layout_byte0=$(hex_byte "$layout_hex" 0)
target=$((1 + layout_byte0 % 12))
stamp=$(deterministic_timestamp)
display_day=$(printf '%s' "$stamp" | cut -c 7-8)
display_hour=$(printf '%s' "$stamp" | cut -c 9-10)
display_minute=$(printf '%s' "$stamp" | cut -c 11-12)
work=$(fresh_workdir)
mkdir -p "$work/backup/projects"

i=1
while [ "$i" -le 12 ]; do
    file="$work/backup/projects/project-$(printf '%02d' "$i").conf"
    if [ "$i" -eq "$target" ]; then
        echo "project_id=$answer" > "$file"
        echo "state=active" >> "$file"
        chmod 750 "$file"
        touch -t "$stamp" "$file"
    else
        echo "project_id=$((20000 + i * 977))" > "$file"
        echo "state=archived" >> "$file"
        if [ $((i % 2)) -eq 0 ]; then chmod 750 "$file"; else chmod 640 "$file"; fi
        touch -t "202405$(printf '%02d' $((1 + i % 28)))1200" "$file"
    fi
    i=$((i + 1))
done
(cd "$work/backup" && tar -cf - projects | gzip -c > "$LEVEL_HOME/projects.tar.gz")

write_readme "Use a verbose tar listing to inspect projects.tar.gz. The authoritative member is executable and has timestamp Jun $display_day at $display_hour:$display_minute. Extract that member and submit its numerical project_id."
cleanup_workdir "$work"
finish_level
