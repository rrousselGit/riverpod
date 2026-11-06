# shellcheck shell=bash
# Runs one queued task for pool.sh: pool_worker.sh <pool dir> "<label>\t<cmd>"
# shellcheck source=common.sh
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"
# shellcheck source=pool.sh
. "$(dirname "${BASH_SOURCE[0]}")/pool.sh"

dir="$1"
label="${2%%$'\t'*}"
cmd="${2#*$'\t'}"
slug="$(pool_slug "$label")"
start=$(date +%s)
(cd "$ROOT" && bash -c "$cmd") >"$dir/$slug.log" 2>&1 </dev/null
status=$?
echo "$status" >"$dir/$slug.status"
if [ "$status" = 0 ]; then mark="ok  "; else mark="FAIL"; fi
printf '  %s %s (%ss)\n' "$mark" "$label" "$(( $(date +%s) - start ))"
exit 0  # keep xargs scheduling the other tasks
