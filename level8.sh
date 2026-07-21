#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

answer_hex=$(derive_hex answer)
list_index=$(($(hex_byte "$answer_hex" 0) % 16))
word_index=$(($(hex_byte "$answer_hex" 1) % 16))
answer=$(sed -n "$((list_index + 1))p" "$INSTALL_ROOT/wordgrid.txt" | awk -v n="$((word_index + 1))" '{print $n}')
layout_hex=$(derive_hex layout)
release="release-$((2 + $(hex_byte "$layout_hex" 0) % 8)).$((1 + $(hex_byte "$layout_hex" 1) % 9))"
work=$(fresh_workdir)
mkdir -p "$work/$release/config" "$work/$release/data/lists" "$work/$release/src"

i=0
while [ "$i" -lt 16 ]; do
    sed -n "$((i + 1))p" "$INSTALL_ROOT/wordgrid.txt" | tr ' ' '\n' > "$work/$release/data/lists/set-$(printf '%02d' "$i").txt"
    i=$((i + 1))
done
{
    echo "ACTIVE_LIST=$list_index"
    echo "ACTIVE_ENTRY=$word_index"
    echo "INDEX_BASE=0"
} > "$work/$release/config/release.conf"
echo "This release reads config/release.conf and data/lists/set-NN.txt." > "$work/$release/README"
echo "int main(void) { return 0; }" > "$work/$release/src/main.c"
(cd "$work" && tar -cf - "$release" | xz -c > "$LEVEL_HOME/$release.tar.xz")

write_readme "Extract the tar.xz source release. Read config/release.conf, then submit the selected entry from data/lists. Both list and entry numbering start at zero."
record_answer "$answer"
cleanup_workdir "$work"
finish_level
