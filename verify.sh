#!/bin/sh
set -eu

ANSWER_DIR=${ANSWER_DIR:-/var/lib/compression-bandit/answers}
failures=0
work=$(mktemp -d /tmp/compression-bandit-verify.XXXXXX)
trap 'rm -rf "$work"' EXIT HUP INT TERM

check() {
    level=$1
    actual=$2
    expected=$(sed -n '1p' "$ANSWER_DIR/level$level")
    if [ "$actual" = "$expected" ]; then
        echo "level$level: PASS"
    else
        echo "level$level: FAIL (reference solver returned '$actual')" >&2
        failures=$((failures + 1))
    fi
}

actual=$(gzip -dc /home/level1/*.gz | sed -n 's/^The flag for this level is //p')
check 1 "$actual"

actual=$(bzip2 -dc /home/level2/*.bz2 | awk '$3 == "compression-desk" {print $2}')
check 2 "$actual"

actual=$(xz -dc /home/level3/payload.bin | sed -n 's/^release-token: //p')
check 3 "$actual"

mkdir "$work/l4"
tar -xf /home/level4/records.tar -C "$work/l4"
list=$(awk '/^List:/ {print $2}' "$work/l4/INDEX.txt")
entry=$(awk '/^Entry:/ {print $2}' "$work/l4/INDEX.txt")
list_file=$(printf '%02d' "$list")
actual=$(awk -v n="$((entry + 1))" '{print $n}' "$work/l4/reports/list-$list_file.txt")
check 4 "$actual"

mkdir "$work/l5"
unzip -qq /home/level5/project-records.zip -d "$work/l5"
project=$(sed -n 's/.*project \(PRJ-[0-9][0-9]*\).*/\1/p' "$work/l5/CATALOG.txt")
record=$(grep -l "^Project: $project$" "$work/l5"/documents/*)
actual=$(sed -n 's/^Approval phrase: //p' "$record")
check 5 "$actual"

mkdir "$work/l6"
gzip -dc /home/level6/web-logs.tar.gz | tar -xf - -C "$work/l6"
ip=$(sed -n 's/.*requests from \(192\.168\.1\.[0-9][0-9]*\).*/\1/p' /home/level6/README.txt)
actual=$(grep -h "^$ip " "$work/l6"/logs/access.log* | wc -l | tr -d ' ')
check 6 "$actual"

mkdir "$work/l7"
bzip2 -dc /home/level7/mail-backup.tar.bz2 | tar -xf - -C "$work/l7"
sender=$(sed -n 's/.*message from \([^ ]*@example\.net\).*/\1/p' /home/level7/README.txt)
message=$(grep -rl "^From: $sender$" "$work/l7/Maildir")
actual=$(sed -n 's/^Recovery token: //p' "$message")
check 7 "$actual"

mkdir "$work/l8"
xz -dc /home/level8/*.tar.xz | tar -xf - -C "$work/l8"
release=$(find "$work/l8" -mindepth 1 -maxdepth 1 -type d | head -n 1)
list=$(sed -n 's/^ACTIVE_LIST=//p' "$release/config/release.conf")
entry=$(sed -n 's/^ACTIVE_ENTRY=//p' "$release/config/release.conf")
list_file=$(printf '%02d' "$list")
actual=$(sed -n "$((entry + 1))p" "$release/data/lists/set-$list_file.txt")
check 8 "$actual"

mkdir "$work/l9"
gzip -dc /home/level9/projects.tar.gz | tar -xf - -C "$work/l9"
target=$(grep -rl '^state=active$' "$work/l9/projects")
actual=$(sed -n 's/^project_id=//p' "$target")
check 9 "$actual"

mkdir "$work/l10"
unzip -qq /home/level10/incident-bundle.zip -d "$work/l10"
for compressed in "$work/l10"/logs/*.gz; do
    gzip -d "$compressed"
done
ip=$(sed -n 's/^TARGET_IP=//p' "$work/l10/MANIFEST.txt")
request=$(sed -n 's/^REQUEST_ID=//p' "$work/l10/MANIFEST.txt")
actual=$(grep "ip=$ip request=$request " "$work/l10"/logs/* | sed -n 's/.* token=//p')
check 10 "$actual"

if [ "$failures" -ne 0 ]; then
    echo "$failures level(s) failed validation." >&2
    exit 1
fi
echo "All levels passed."
