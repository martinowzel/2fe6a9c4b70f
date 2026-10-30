#!/usr/bin/env bash
set -u
BASE="/workspaces/ps4-bd-jb/sources/repos"
LOG="/workspaces/ps4-bd-jb/sources/clones.log"
: > "$LOG"
clone_one() {
  local name="$1" url="$2" extra="${3:-}"
  local dir="$BASE/$name"
  if [ -d "$dir/.git" ]; then
    echo "SKIP (exists) $name" | tee -a "$LOG"
    return 0
  fi
  rm -rf "$dir"
  echo "CLONE $name <- $url" | tee -a "$LOG"
  if git clone --depth 1 $extra "$url" "$dir" >>"$LOG" 2>&1; then
    local commit
    commit=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null || echo "unknown")
    echo "OK $name $commit" | tee -a "$LOG"
  else
    echo "FAIL $name" | tee -a "$LOG"
  fi
}
clone_one "TheOfficialFloW-bd-jb" "https://github.com/TheOfficialFloW/bd-jb.git"
clone_one "TheOfficialFloW-Presentations" "https://github.com/TheOfficialFloW/Presentations.git"
clone_one "ps3120-BD-JB-1250" "https://github.com/ps3120/BD-JB-1250.git"
clone_one "ayasns-BD-JB-1250" "https://github.com/ayasns/BD-JB-1250.git"
clone_one "DefKorns-BD-JB-1252" "https://github.com/DefKorns/BD-JB-1252.git"
clone_one "GoldHEN-henloader_lp" "https://github.com/GoldHEN/henloader_lp.git"
clone_one "ps3120-henloader_lp" "https://github.com/ps3120/henloader_lp.git"
clone_one "iaceene-HENloader_Source" "https://github.com/iaceene/HENloader_Source.git"
clone_one "kimariin-BlueLoader" "https://github.com/kimariin/BlueLoader.git"
clone_one "john-tornblom-bdj-sdk" "https://github.com/john-tornblom/bdj-sdk.git" "--recurse-submodules --shallow-submodules"
clone_one "ps4-payload-dev-sdk" "https://github.com/ps4-payload-dev/sdk.git"
clone_one "ps5-payload-dev-sdk" "https://github.com/ps5-payload-dev/sdk.git"
clone_one "Gezine-BD-JB5" "https://github.com/Gezine/BD-JB5.git"
clone_one "GoldHEN-GoldHEN" "https://github.com/GoldHEN/GoldHEN.git"
clone_one "Scene-Collective-ps4-hen" "https://github.com/Scene-Collective/ps4-hen.git"
clone_one "iMrDJAi-laps3c0re" "https://github.com/iMrDJAi/laps3c0re.git"
clone_one "Al-Azif-psfree-lapse" "https://github.com/Al-Azif/psfree-lapse.git"
clone_one "kmeps4-PSFree" "https://github.com/kmeps4/PSFree.git"
clone_one "shahrilnet-remote_lua_loader" "https://github.com/shahrilnet/remote_lua_loader.git"
clone_one "adri22235-ps4-suid-scanner" "https://github.com/adri22235/ps4-suid-scanner.git"
clone_one "ps3120-ps3120.github.io" "https://github.com/ps3120/ps3120.github.io.git"
clone_one "hammer-83-ps5-jar-loader" "https://github.com/hammer-83/ps5-jar-loader.git"
clone_one "CTurt-FreeDVDBoot" "https://github.com/CTurt/FreeDVDBoot.git"
clone_one "sleirsgoevy-bdj-doom" "https://github.com/sleirsgoevy/bdj-doom.git"
clone_one "Gezine-Y2JB" "https://github.com/Gezine/Y2JB.git"
clone_one "sleirsgoevy-ps4jb-payloads" "https://github.com/sleirsgoevy/ps4jb-payloads.git"
# gist (Poopsploit)
GDIR="/workspaces/ps4-bd-jb/sources/gists/poopsploit"
if [ -d "$GDIR/.git" ]; then echo "SKIP (exists) poopsploit-gist" | tee -a "$LOG"; else
  rm -rf "$GDIR"
  echo "CLONE poopsploit-gist" | tee -a "$LOG"
  if git clone --depth 1 "https://gist.github.com/7174351201b5260d7780780f4059bebf.git" "$GDIR" >>"$LOG" 2>&1; then
    echo "OK poopsploit-gist $(git -C "$GDIR" rev-parse --short HEAD 2>/dev/null || echo unknown)" | tee -a "$LOG"
  else
    echo "FAIL poopsploit-gist" | tee -a "$LOG"
  fi
fi
echo "DONE" | tee -a "$LOG"
