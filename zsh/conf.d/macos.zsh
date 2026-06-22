# macOS /usr/sbin "hidden gems" — reusable wrappers
[[ "$OSTYPE" == darwin* ]] || return

# --- taskpolicy: run heavy jobs without bogging down the Mac -----------------

# Run a command at background CPU + I/O priority.
# usage: bgrun rsync -a src/ dst/
bgrun() {
  [[ $# -gt 0 ]] || { echo "usage: bgrun <command> [args...]"; return 1 }
  taskpolicy -c background -b "$@"
}

# Throttle / un-throttle an ALREADY-running process by PID.
bgpid()   { [[ -n "$1" ]] && taskpolicy -b -p "$1" || echo "usage: bgpid <pid>" }
unbgpid() { [[ -n "$1" ]] && taskpolicy -B -p "$1" || echo "usage: unbgpid <pid>" }

# --- screencapture: screenshots & screen video -------------------------------

# Interactive screenshot → clipboard, silent. Paste with ⌘V.
shot() { screencapture -icx }

# Interactive screenshot → ~/Desktop/shot-<timestamp>.png, silent.
shotf() {
  local f="$HOME/Desktop/shot-$(date +%Y%m%d-%H%M%S).png"
  screencapture -ix "$f" && echo "$f"
}

# Record screen video → ~/Desktop/rec-<timestamp>.mov (Control-C to stop).
rec() {
  local f="$HOME/Desktop/rec-$(date +%Y%m%d-%H%M%S).mov"
  echo "Recording → $f  (press Control-C to stop)"
  screencapture -v "$f"
}

# --- system_profiler: scriptable machine inventory ---------------------------

# Hardware + software overview, or any data type: `sysinfo SPMemoryDataType`.
# `sysinfo -l` lists every available data type.
sysinfo() {
  case "$1" in
    -l|--list) system_profiler -listDataTypes ;;
    "")        system_profiler SPHardwareDataType SPSoftwareDataType ;;
    *)         system_profiler "$@" ;;
  esac
}

# Battery cycle count + condition (needs jq).
battery() {
  system_profiler -json SPPowerDataType \
    | jq -r '.SPPowerDataType[] | select(.sppower_battery_health_info)
             | .sppower_battery_health_info
             | "cycles: \(.sppower_battery_cycle_count)   condition: \(.sppower_battery_health)"'
}

# --- purge: honest cold-cache benchmarking -----------------------------------

# Flush the disk cache, then run a command cold and time it.
# usage: coldrun cat bigfile.dat > /dev/null
coldrun() {
  [[ $# -gt 0 ]] || { echo "usage: coldrun <command> [args...]"; return 1 }
  sudo purge && time "$@"
}

# --- mtree: snapshot a tree, detect drift later ------------------------------

# Record a baseline (perms/owner/size/sha256) of a directory tree.
# usage: treesnap <dir> [specfile]   (spec defaults to <dir>.mtree)
treesnap() {
  local dir="${1:?usage: treesnap <dir> [specfile]}"
  local spec="${2:-${dir%/}.mtree}"
  mtree -c -p "$dir" -K sha256digest > "$spec" && echo "baseline → $spec"
}

# Compare a directory against its baseline; non-zero exit = drift found.
# usage: treecheck <dir> [specfile]
treecheck() {
  local dir="${1:?usage: treecheck <dir> [specfile]}"
  local spec="${2:-${dir%/}.mtree}"
  mtree -p "$dir" -K sha256digest < "$spec"
}
