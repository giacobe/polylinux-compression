# Buildroot tool requirements

The intended BuildrootBuilder2 profile is `basic + compression`. Required
commands are:

- Basic tools: `sh`, `awk`, `sed`, `grep`, `sort`, `cut`, `tr`, `find`,
  `file`, `od`, `sha256sum`, `base64`, `xxd`
- Compression tools: `tar`, `gzip`, `bzip2`, `xz`, `zip`, `unzip`
- Installation tools: `adduser`, `passwd`, `su`, `chown`, `chmod`, `touch`

The levels avoid 7-Zip, cpio, ar, zstd, and filesystem-image formats. ZIP
creation is needed only during installation; learners need `unzip`.

