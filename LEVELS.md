# Level design

All answers are deterministic functions of the per-level SHA-256 seed. Noise,
member ordering, filenames, target records, and metadata use labeled sub-hashes
of the same seed.

| Level | Artifact | Main learner action | Answer type |
|---|---|---|---|
| 1 | `.gz` text file | Decompress gzip | 12-character Base64url Easter egg |
| 2 | `.bz2` table | Decompress bzip2 and select a record | Numerical ticket |
| 3 | extensionless xz stream | Identify with `file`, decompress xz | 14-character Base64url token |
| 4 | plain `.tar` | List/extract archive and apply two indexes | Word from a 16×16 grid |
| 5 | `.zip` document bundle | Extract ZIP and correlate catalog entry | Phrase from a 16-item list |
| 6 | `.tar.gz` rotated logs | Extract and count an IP across logs | Numerical request count |
| 7 | `.tar.bz2` Maildir | Search sender/date headers | Base64url mail token |
| 8 | `.tar.xz` source release | Correlate config and indexed list | Word from a 16×16 grid |
| 9 | `.tar.gz` project backup | Inspect permissions and timestamps | Numerical project ID |
| 10 | ZIP plus one gzip member | Correlate manifest and session logs | 16-character Base64url flag |

## Generator invariants

- The format taught by a level never changes with the seed.
- Each clue identifies exactly one target.
- Answers are derived before noise is constructed.
- Noise values are constructed so they cannot equal the target selector.
- No answer depends on archive member ordering or alphabetical position.
- Level 10 is the only level with a second compression layer not inherent in a
  conventional `tar.*` pairing.

## Grader interface

After installation, read the exact expected answer from:

```text
```

file contains one answer followed by a newline.

