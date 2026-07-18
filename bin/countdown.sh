#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: countdown.sh <duration>"
  echo ""
  echo "Examples: 30s, 2m, 1.5h, 1h30m, 5 (bare number = minutes)"
  exit 1
}

[[ $# -eq 0 ]] && usage

input="$*"
# Strip spaces so "30 sec" becomes "30sec"
input="${input// /}"
# Lowercase
input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

total_seconds=0

parse_duration() {
  local s="$1"

  # Compound: 1h30m, 2h45m30s
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)h([0-9]+(\.[0-9]+)?)m([0-9]+(\.[0-9]+)?)s$ ]]; then
    local h="${BASH_REMATCH[1]}" m="${BASH_REMATCH[3]}" sec="${BASH_REMATCH[5]}"
    total_seconds=$(awk "BEGIN {printf \"%d\", $h*3600 + $m*60 + $sec}")
    return
  fi
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)h([0-9]+(\.[0-9]+)?)m$ ]]; then
    local h="${BASH_REMATCH[1]}" m="${BASH_REMATCH[3]}"
    total_seconds=$(awk "BEGIN {printf \"%d\", $h*3600 + $m*60}")
    return
  fi
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)h([0-9]+(\.[0-9]+)?)s$ ]]; then
    local h="${BASH_REMATCH[1]}" sec="${BASH_REMATCH[3]}"
    total_seconds=$(awk "BEGIN {printf \"%d\", $h*3600 + $sec}")
    return
  fi
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)m([0-9]+(\.[0-9]+)?)s$ ]]; then
    local m="${BASH_REMATCH[1]}" sec="${BASH_REMATCH[3]}"
    total_seconds=$(awk "BEGIN {printf \"%d\", $m*60 + $sec}")
    return
  fi

  # Single unit
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)(s|sec|secs|second|seconds)$ ]]; then
    total_seconds=$(awk "BEGIN {printf \"%d\", ${BASH_REMATCH[1]}}")
    return
  fi
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)(m|min|mins|minute|minutes)$ ]]; then
    total_seconds=$(awk "BEGIN {printf \"%d\", ${BASH_REMATCH[1]}*60}")
    return
  fi
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)(h|hr|hrs|hour|hours)$ ]]; then
    total_seconds=$(awk "BEGIN {printf \"%d\", ${BASH_REMATCH[1]}*3600}")
    return
  fi

  # Bare number = minutes
  if [[ "$s" =~ ^([0-9]+(\.[0-9]+)?)$ ]]; then
    total_seconds=$(awk "BEGIN {printf \"%d\", ${BASH_REMATCH[1]}*60}")
    return
  fi

  echo "Error: cannot parse duration '$s'"
  usage
}

parse_duration "$input"

if [[ "$total_seconds" -le 0 ]]; then
  echo "Error: duration must be positive"
  exit 1
fi

format_time() {
  local t=$1
  local h=$((t / 3600))
  local m=$(( (t % 3600) / 60 ))
  local s=$((t % 60))
  if [[ $h -gt 0 ]]; then
    printf "%02d:%02d:%02d" "$h" "$m" "$s"
  else
    printf "%02d:%02d" "$m" "$s"
  fi
}

remaining=$total_seconds
while [[ $remaining -ge 0 ]]; do
  printf "\r%s " "$(format_time $remaining)"
  [[ $remaining -eq 0 ]] && break
  sleep 1
  remaining=$((remaining - 1))
done

echo ""

# Alerts
osascript -e 'display notification "Timer done" with title "Countdown" sound name "Glass"' 2>/dev/null || true
printf "\a"
echo "Timer done!"
say "time is up" &
