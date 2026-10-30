#!/usr/bin/env bash
# Clone the PS4 14.00 research/tooling repositories into sources/repos/.
# Run from the project root. Existing clones are skipped.
set -u
BASE="sources/repos"
LOG="sources/clones.log"
clone_one() {
  local name="$1" url="$2"
  local dir="$BASE/$name"
  if [ -d "$dir/.git" ]; then
    echo "SKIP (exists) $name" | tee -a "$LOG"
    return 0
  fi
  rm -rf "$dir"
  echo "CLONE $name <- $url" | tee -a "$LOG"
  if git clone --depth 1 "$url" "$dir" >>"$LOG" 2>&1; then
    echo "OK $name $(git -C "$dir" rev-parse --short HEAD 2>/dev/null || echo unknown)" | tee -a "$LOG"
  else
    echo "FAIL $name" | tee -a "$LOG"
  fi
}

# WebKit / userland research
clone_one "ntfargo-CSSFontFace-Exploit" "https://github.com/ntfargo/CSSFontFace-Exploit.git"
clone_one "ps3120-CSSFontFace-Exploit" "https://github.com/ps3120/CSSFontFace-Exploit.git"
clone_one "ps3120-FontFace-Lapse" "https://github.com/ps3120/FontFace-Lapse.git"
clone_one "OptiTronOffical-1350-webkit-test" "https://github.com/OptiTronOffical/1350-webkit-test.git"

# 14.00 research workspaces
clone_one "Mikadolebg-ps4-1400-research" "https://github.com/Mikadolebg/ps4-1400-research.git"
clone_one "siongadev-PS4-14.00-Jailbreak-Research" "https://github.com/siongadev/PS4-14.00-Jailbreak-Research.git"
clone_one "adri22235-ps4-14-00-security-notes" "https://github.com/adri22235/ps4-14-00-security-notes.git"

# PUP decrypt/unpack tooling
clone_one "ps3120-ps4-pup-decrypt" "https://github.com/ps3120/ps4-pup-decrypt.git"
clone_one "Scene-Collective-ps4-pup-decrypt" "https://github.com/Scene-Collective/ps4-pup-decrypt.git"
clone_one "iHaiDeeZ-PupDecrypt-PS4" "https://github.com/iHaiDeeZ/PupDecrypt-PS4.git"
clone_one "idc-ps4-pup_decrypt" "https://github.com/idc/ps4-pup_decrypt.git"
clone_one "idc-ps4-pup_unpack" "https://github.com/idc/ps4-pup_unpack.git"
clone_one "andy-man-ps4-pup-decrypt" "https://github.com/andy-man/ps4-pup-decrypt.git"
clone_one "Scene-Collective-ps4-payload-sdk" "https://github.com/Scene-Collective/ps4-payload-sdk.git"

# Post-exploitation / kernel patch references
clone_one "ps3120-ps4-exploit-kpatches" "https://github.com/ps3120/ps4-exploit-kpatches.git"

echo "DONE" | tee -a "$LOG"
