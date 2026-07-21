#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer="flag-$(answer_token 16)"
answer_hex=$(derive_hex answer)
answer_byte20=$(hex_byte "$answer_hex" 20)
answer_byte21=$(hex_byte "$answer_hex" 21)
answer_byte22=$(hex_byte "$answer_hex" 22)
answer_byte23=$(hex_byte "$answer_hex" 23)
host_octet=$((1 + answer_byte20 % 254))
request_id=$((100000 + (answer_byte21 * 256 + answer_byte22) % 900000))
rotation=$((1 + answer_byte23 % 4))
target_ip="10.44.7.$host_octet"
work=$(fresh_workdir)
mkdir -p "$work/incident/logs" "$work/incident/notes"

echo "Incident bundle - routine network triage" > "$work/incident/notes/README.txt"
for n in 1 2 3 4; do
    log="$work/incident/logs/gateway.log.$n"
    i=1
    while [ "$i" -le 20 ]; do
        octet=$((1 + (host_octet + n * 31 + i * 7) % 254))
        echo "2024-06-18T14:$(printf '%02d' "$i"):00Z ip=10.44.7.$octet request=$((200000 + n * 100 + i)) status=closed" >> "$log"
        i=$((i + 1))
    done
done
echo "2024-06-18T15:42:00Z ip=$target_ip request=$request_id status=recovered token=$answer" >> "$work/incident/logs/gateway.log.$rotation"
gzip -c < "$work/incident/logs/gateway.log.$rotation" > "$work/incident/logs/gateway.log.$rotation.gz"
rm "$work/incident/logs/gateway.log.$rotation"
{
    echo "TARGET_IP=$target_ip"
    echo "REQUEST_ID=$request_id"
    echo "Search all gateway log rotations and submit the token on that session."
} > "$work/incident/MANIFEST.txt"
(cd "$work/incident" && zip -qr "$LEVEL_HOME/incident-bundle.zip" MANIFEST.txt logs notes)

write_readme "Unpack incident-bundle.zip and follow MANIFEST.txt. One rotated log is itself gzip-compressed. Submit the token associated with both the target IP and request ID."
record_answer "$answer"
cleanup_workdir "$work"
finish_level
