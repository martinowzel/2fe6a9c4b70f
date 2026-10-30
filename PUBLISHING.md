# Publication Notes

This repository is a **documentation and data snapshot** of the PS4 BD-JB / PS4 14.00 research project.

## Included

- `README.md` — project overview and status.
- `docs/` — English documentation (`docs/en/`) and the Persian mirror (`docs/*.md`).
- `data/` — firmware compatibility CSV, source metadata, clone inventory, candidate CVE records, and the 14.00 research status/leads JSON.
- `resources/` — quick links (English/Persian).
- `sources/README.md`, `sources/clones.log`, and the two clone scripts — provenance and reproducibility.

## Not included

- `sources/repos/` — 41 upstream Git repositories (~835 MB). They are shallow, read-only reference clones with nested `.git` directories and upstream binaries/artifacts. Recreate them with `sources/clone-repos.sh` and `sources/clone-1400-research.sh`.
- `sources/gists/` — the Poopsploit gist clone. Clone URL is in `sources/README.md`.
- `sources/web/` — local PDF/HTML snapshots of third-party pages (Sony, PSDevWiki, ConsoleMods, HENloader, hardwear.io). They are excluded for size and copyright/licensing reasons. The original links are preserved in `docs/en/12-sources.md`.

## Reproduce the local archive

```bash
git clone <this-repo> ps4-bd-jb-docs
cd ps4-bd-jb-docs
mkdir -p sources/repos sources/gists sources/web
bash sources/clone-repos.sh
bash sources/clone-1400-research.sh
# gist
git clone --depth 1 https://gist.github.com/7174351201b5260d7780780f4059bebf.git sources/gists/poopsploit
```

The clone scripts log status to `sources/clones.log`; the inventory in `sources/README.md` records the exact commit hashes from the snapshot date.

## Scope and safety

- The project is educational/security-research documentation for personally owned consoles.
- No exploit binaries, copyrighted firmware, keys, or game content are included.
- The PS4 14.00 research is **community-reported**; there is no public kernel exploit or full jailbreak as of 2026-10-30. A private/teaser jailbreak is discussed but is not public or reproducible.
- `14.10` is a **PS5** firmware, not PS4.
- Do not use this material for piracy, online cheating, or illegal activity. Local laws and Sony's ToS apply.

## Source licensing

Cloned upstream repositories, when recreated locally, remain under their own licenses. This repository does not claim ownership of upstream code, firmware-derived artifacts, or third-party documentation.
