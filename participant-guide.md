---
title: "PolyLinux Compression"
short_title: "Compression"
panel_title: "Learning Path"
form_url: "https://forms.microsoft.com/Pages/ResponsePage.aspx?id=RY30fNs9iUOpwcEVUm61LvTNagO6dAdDlZnocMnGFFZUMUE2S0tZNFhBWFNMWDE4R0VYSEQ5TVdBOS4u"

---

# Compression Bandit: Participant Guide

Welcome to Compression Bandit, a ten-level Linux command-line exercise about
compressed files and archives. Each level gives you one artifact to inspect.
Your task is to recover one answer from that artifact.

The levels begin with individual compression formats and gradually introduce
archives, backups, logs, email, metadata, and nested real-world data.

## Getting started

Log in as `root`; no password is required. The root profile starts the
installer automatically. Enter and confirm your email address when prompted.
The installer displays an exercise code, selects one of sixteen fictional
themes for the complete attempt, and enters `level1` as soon as it is ready.
The remaining levels continue building in parallel. Your home directory
contains:

- `README.txt`, which gives the exact task for your current level.
- One compressed file or archive containing the level data.

Always begin with:

```sh
pwd
ls -la
cat README.txt
```

Submit the answer through the external exercise form. The VM does not grade
answers or provide correctness feedback. Answers are case-sensitive and must
be entered exactly as discovered. Preserve spaces, hyphens, underscores, and
capitalization. Do not add quotation marks unless they are part of the answer.

Use these commands to move between levels:

```sh
nextlevel
prevlevel
```

## A useful working method

Before extracting an unfamiliar artifact, make a private working directory:

```sh
mkdir work
cp NAME-OF-ARTIFACT work/
cd work
```

Some decompression commands replace or remove the compressed input file. A
working copy lets you start again without rebuilding the level.

For each artifact, use the following process:

1. Read `README.txt` carefully.
2. Inspect the filename and determine the likely format.
3. Confirm the type with `file` when the extension is missing or questionable.
4. List archive contents before extracting when the format supports it.
5. Extract or decompress the data.
6. Inspect the resulting files with ordinary text tools.
7. Apply the clue from `README.txt` to identify the single expected answer.

## Compression versus archiving

Compression and archiving are related but different operations.

- `gzip`, `bzip2`, and `xz` normally compress one stream or file.
- `tar` combines multiple files and directories into one archive. A plain tar
  archive is not necessarily compressed.
- ZIP normally performs both archiving and compression.
- Extensions such as `.tar.gz`, `.tar.bz2`, and `.tar.xz` describe a tar
  archive compressed with a second tool.

This distinction is central to several levels.

## Command reference

### Identify a file

```sh
file filename
```

Do not assume that a filename extension is correct.

### gzip

Decompress a file in place:

```sh
gzip -d filename.gz
```

Read decompressed content without removing the original:

```sh
gzip -dc filename.gz
```

### bzip2

Decompress a file in place:

```sh
bzip2 -d filename.bz2
```

Read decompressed content without removing the original:

```sh
bzip2 -dc filename.bz2
```

### xz

Decompress a file in place:

```sh
xz -d filename.xz
```

Write decompressed content to standard output:

```sh
xz -dc filename
```

The second form is useful when a compressed file has an unusual extension.

### tar

List an archive without extracting it:

```sh
tar -tf archive.tar
```

Display a verbose listing, including permissions and timestamps:

```sh
tar -tvf archive.tar
```

Extract an archive:

```sh
tar -xf archive.tar
```

Extract into a chosen directory:

```sh
mkdir extracted
tar -xf archive.tar -C extracted
```

For maximum portability, a compressed tar archive can be handled as a
pipeline:

```sh
gzip -dc archive.tar.gz | tar -xf -
bzip2 -dc archive.tar.bz2 | tar -xf -
xz -dc archive.tar.xz | tar -xf -
```

### ZIP

List a ZIP archive:

```sh
unzip -l archive.zip
```

Extract it:

```sh
mkdir extracted
unzip archive.zip -d extracted
```

## Text investigation tools

You will often need to search or count records after extraction.

Display a file:

```sh
cat filename
```

Search one or more files:

```sh
grep 'search text' filename
grep 'search text' directory/*
```

Search recursively through directories:

```sh
grep -r 'search text' directory
```

Count matching lines:

```sh
grep 'search text' filename | wc -l
```

Search several rotated logs and count all matches:

```sh
grep -h 'search text' access.log* | wc -l
```

Display a numbered selection from a file:

```sh
sed -n '5p' filename
```

Remember that `sed -n '1p'` selects the first line. If a clue explicitly says
that its indexes begin at zero, index zero corresponds to line or item one in
most shell commands.

## Level overview

### Level 1: gzip

Learn how to decompress a gzip-compressed text file and read its contents.

### Level 2: bzip2

Decompress a bzip2 file, inspect a small table, and select the record described
in `README.txt`.

### Level 3: xz and file identification

The filename does not reveal its real format. Use `file`, select the correct
decompression tool, and locate the requested token.

### Level 4: tar archives

Work with an uncompressed tar archive. Inspect its index and use the supplied
zero-based list and entry numbers.

### Level 5: ZIP archives

List and extract a ZIP document bundle. Use its catalog to identify the
authoritative project record.

### Level 6: tar.gz web logs

Extract a conventional gzip-compressed tar backup. Search all rotated access
logs and calculate the requested count.

### Level 7: tar.bz2 mail backup

Extract a Maildir-style backup. Search message headers for the required sender
and date, then inspect the matching message body.

### Level 8: tar.xz source release

Extract a source-release archive. Correlate configuration values with an
indexed data file. Pay close attention to the stated index base.

### Level 9: archive metadata

Use a verbose tar listing. File permissions and timestamps—not merely file
contents—identify the authoritative archive member.

### Level 10: incident bundle

Correlate an incident manifest with rotated gateway logs. One member is still
gzip-compressed after the outer ZIP archive is extracted.

## General advice

- Read command error messages; they often explain what assumption was wrong.
- Use `file` again whenever extraction produces an unfamiliar artifact.
- Prefer listing an archive before extracting it.
- Use tab completion to avoid typing long filenames incorrectly.
- Quote filenames containing spaces: `cat "file with spaces"`.
- Do not search only the first file when the instructions mention rotations,
  directories, or an entire backup.
- Keep a note of completed answers and useful commands outside the level home
  directories. Rebuilding the exercise resets those directories.

The objective is not to guess generated values. Every answer can be recovered
from the files and clues supplied in its level.
