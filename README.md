# Compression Bandit

Compression Bandit is a ten-level command-line exercise derived from the
compression lesson in OverTheWire Bandit. It uses the same flat,
installer-oriented style as PolyBandit3.1, but all level data is generated
deterministically from one SHA-256 seed per learner and level.

The progression is gzip, bzip2, xz, tar, ZIP, realistic tar-compressed
backups, archive metadata, and a two-layer incident bundle.

## Installation

Copy this repository into the Buildroot image's `/root` directory and run:

```sh
chmod +x install.sh level*.sh nextlevel prevlevel checklevel verify.sh
./install.sh
```

The installer creates users `level1` through `level10` and expects to run as
root. Re-running it resets those ten home directories before rebuilding them,
so learner work stored there is not retained.

For non-interactive image testing:

```sh
USER_ID=student@example.edu CURRENT_DATE=2026-07-20 \
SYSTEM_PASSWORD=exercisePassword ./install.sh --non-interactive --no-login
```

## Seed contract

Each level hashes this exact UTF-8 byte sequence, without a trailing newline:

```text
email + date + exercise_password + level_password
```

The date is ISO `YYYY-MM-DD`. Default level passwords are `levelPassword1`
through `levelPassword10`. Labeled SHA-256 sub-hashes produce independent
answer, layout, noise, and filename parameters.

## Grading

Expected answers are installed root-only under
`/var/lib/compression-bandit/answers/`. External graders can read these files.
Run `./verify.sh` as root after installation to exercise the reference solvers.

See `LEVELS.md` for the curriculum and `TOOLSET.md` for dependencies.

## Build the browser VM

This lab uses the `basic-compression` configuration from
[`giacobe/buildroot-builder2`](https://github.com/giacobe/buildroot-builder2),
validated with Buildroot `2025.02.15`:

```sh
git clone https://github.com/giacobe/buildroot-builder2.git
cd buildroot-builder2
BUILDROOT_VERSION=2025.02.15 scripts/01-setup-buildroot.sh
scripts/02-build-baseline.sh --config basic-compression
scripts/03-package-payload.sh \
  --repo https://github.com/giacobe/polylinux-compression.git \
  --ref main \
  --baseline artifacts/basic-compression-<timestamp> \
  --output artifacts/polylinux-compression \
  --output-prefix polylinux-compression
```

Replace `<timestamp>` with the stage-2 artifact directory. Review the manifest,
verify every compression command in `TOOLSET.md`, and boot-test the exact
generated image pair in v86 before publishing.
