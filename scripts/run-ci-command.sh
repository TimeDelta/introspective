#!/usr/bin/env bash
# Preserve complete diagnostics without making compiler progress wait on console log delivery.
set -euo pipefail
ci_command_log=$1
shift
mkdir -p "$(dirname "$ci_command_log")"
run_logged_command() {
  if [ "${CI_TEST_PROGRESS:-0}" = 1 ]; then
    # Keep the full diagnostic log, but stream only case completions. UI suites
    # take minutes; hiding all progress until the command exits looks like a hang.
    "$@" 2>&1 | tee "$ci_command_log" | python3 -u -c '
import re, sys
case = re.compile(r"Test Case .* (passed|failed) \(|Test case .* (passed|failed) on ")
for line in sys.stdin:
    if case.search(line):
        print(line, end="", flush=True)
'
  else
    "$@" > "$ci_command_log" 2>&1
  fi
}
if run_logged_command "$@"; then
  tail -n 40 "$ci_command_log"
else
  ci_command_status=$?
  # Keep actual assertions and failed case names visible even when startup
  # Core Data diagnostics consume the first error lines and artifact upload fails.
  # The complete log still retains those framework diagnostics.
  awk '/CoreData: error:/ && !/XCTAssert|XCTest issue/ { next }
    /error:|fatal error:|XCTest issue|Test [Cc]ase.*failed|TEST.*FAILED/ {
      print; count++; if (count == 30) exit
    }' "$ci_command_log" >&2
  tail -n 90 "$ci_command_log" >&2
  exit "$ci_command_status"
fi
