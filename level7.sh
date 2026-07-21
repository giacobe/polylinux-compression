#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer="mail-$(answer_token 13)"
answer_hex=$(derive_hex answer)
senders="alex blair casey devon ellis frankie gray harper"
answer_byte20=$(hex_byte "$answer_hex" 20)
answer_byte21=$(hex_byte "$answer_hex" 21)
answer_byte22=$(hex_byte "$answer_hex" 22)
sender_name=$(pick_from_words "$senders" "$answer_byte20")
sender="$sender_name@example.net"
day=$((10 + answer_byte21 % 15))
target=$((1 + answer_byte22 % 12))
work=$(fresh_workdir)
mkdir -p "$work/mail/Maildir/cur" "$work/mail/Maildir/new"

i=1
while [ "$i" -le 12 ]; do
    folder=cur
    [ $((i % 3)) -eq 0 ] && folder=new
    if [ "$i" -eq "$target" ]; then
        from=$sender
        msgday=$day
        body="Recovery token: $answer"
    else
        from="notice-$i@example.net"
        msgday=$((10 + (day + i) % 15))
        body="Routine archive notice $i. No action is required."
    fi
    {
        echo "From: $from"
        echo "To: archive@example.edu"
        echo "Date: $(printf '%02d' "$msgday") Jun 2024 09:00:00 +0000"
        echo "Subject: Archive message $i"
        echo
        echo "$body"
    } > "$work/mail/Maildir/$folder/message-$i.eml"
    i=$((i + 1))
done
(cd "$work/mail" && tar -cf - Maildir | bzip2 -c > "$LEVEL_HOME/mail-backup.tar.bz2")

write_readme "Extract mail-backup.tar.bz2. Find the message from $sender dated $(printf '%02d' "$day") Jun 2024 and submit its Recovery token."
record_answer "$answer"
cleanup_workdir "$work"
finish_level
