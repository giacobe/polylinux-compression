#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer="egg-$(answer_token 12)"
names="welcome memo note parcel message readme"
name_hex=$(derive_hex names)
name=$(pick_from_words "$names" "$(hex_byte "$name_hex" 0)")
work=$(fresh_workdir)

{
    echo "Compression desk memo"
    echo "The flag for this level is $answer"
    echo "Keep a copy in your exercise notes."
} > "$work/$name.txt"
gzip -c < "$work/$name.txt" > "$LEVEL_HOME/$name.txt.gz"

write_readme "The flag is in the gzip-compressed file in this directory. Decompress the file and read its contents."
cleanup_workdir "$work"
finish_level

