# Repository clones (not included in this publication)

The 41 upstream repositories (~835 MB, shallow clones with nested `.git` directories and upstream binaries) are intentionally excluded from this GitHub copy.

Use the scripts to recreate them locally:

```bash
bash sources/clone-repos.sh
bash sources/clone-1400-research.sh
```

The exact upstream URLs and commit hashes are documented in `sources/README.md` and `data/cloned-sources.json`. Upstream licenses remain in effect.
