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
