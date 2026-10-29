#!/usr/bin/env bash
# Preserve complete diagnostics without making compiler progress wait on console log delivery.
set -euo pipefail
ci_command_log=$1
shift
mkdir -p "$(dirname "$ci_command_log")"
if "$@" > "$ci_command_log" 2>&1; then
  tail -n 40 "$ci_command_log"
else
  ci_command_status=$?
  tail -n 120 "$ci_command_log" >&2
  exit "$ci_command_status"
fi
