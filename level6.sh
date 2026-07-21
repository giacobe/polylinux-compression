#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer_hex=$(derive_hex answer)
host_octet=$((1 + $(hex_byte "$answer_hex" 0) % 254))
target_ip="192.168.1.$host_octet"
answer=$((7 + $(hex_byte "$answer_hex" 1) % 18))
layout_hex=$(derive_hex layout)
work=$(fresh_workdir)
mkdir -p "$work/backup/logs"

for log in access.log access.log.1 access.log.2; do
    : > "$work/backup/logs/$log"
done
i=0
while [ "$i" -lt 72 ]; do
    octet=$((1 + (host_octet + i * 17 + 23) % 254))
    if [ "$octet" -eq "$host_octet" ]; then octet=$((octet % 254 + 1)); fi
    logfile=$((i % 3))
    case "$logfile" in
        0) log=access.log ;;
        1) log=access.log.1 ;;
        *) log=access.log.2 ;;
    esac
    code=$((200 + i % 5))
    echo "192.168.1.$octet - - [12/Jun/2024:10:$(printf '%02d' $((i % 60))):00 +0000] \"GET /asset/$i HTTP/1.1\" $code 512" >> "$work/backup/logs/$log"
    i=$((i + 1))
done
i=0
while [ "$i" -lt "$answer" ]; do
    case "$((i % 3))" in
        0) log=access.log ;;
        1) log=access.log.1 ;;
        *) log=access.log.2 ;;
    esac
    echo "$target_ip - - [12/Jun/2024:11:$(printf '%02d' $((i % 60))):00 +0000] \"GET /restricted/report-$i HTTP/1.1\" 200 2048" >> "$work/backup/logs/$log"
    i=$((i + 1))
done
(cd "$work/backup" && tar -cf - logs | gzip -c > "$LEVEL_HOME/web-logs.tar.gz")

write_readme "web-logs.tar.gz is a compressed web-server backup. Extract it and count all requests from $target_ip across every rotated access log. The decimal count is the answer."
record_answer "$answer"
cleanup_workdir "$work"
finish_level

