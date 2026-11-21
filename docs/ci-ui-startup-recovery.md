# UI runner startup recovery

`scripts/run-ui-tests.py` can restart the simulator and retry the identical
`xcodebuild test-without-building` command once when XCTest fails before any
test starts. It covers these observed initialization failures:

- Accessibility initialization times out (`Timed out waiting for AX loaded
  notification` or `Timed out while loading Accessibility`).
- The UI runner is killed before establishing a connection, with both
  `Early unexpected exit, operation never finished bootstrapping - no restart
  will be attempted.` and `Test crashed with signal kill before establishing
  connection.` in the diagnostic.

Recovery requires agreement between the raw log and the result bundle's
`xcresulttool get test-results summary` output. The summary must report exactly
one synthetic `IntrospectiveUITests-Runner (PID) encountered an error` for the
`IntrospectiveUITests` target, zero passed, skipped, or expected-failure tests,
and no real test identifier URL. An Accessibility error must also say the runner
failed to initialize. A killed runner must have its exact identifier and both
kill messages together on a log line and both messages in the summary failure.
Any `Test Case` or `Test Suite` activity in the log prevents recovery, including
timestamp-prefixed output.

The wrapper preserves the failed attempt before restarting. For an invocation
using `ci-output/ui-preflight.log` and `ci-output/UIPreflight.xcresult`, it keeps:

- `ci-output/ui-preflight-startup-failure.log`
- `ci-output/ui-preflight-startup-failure.summary.json`
- `ci-output/UIPreflight-startup-failure.xcresult`
- `ci-output/ui-preflight-simulator-recovery.log` for simulator commands

The workflow uploads `ci-output/`, including these diagnostics. Existing saved
diagnostics are never overwritten. A missing bundle, malformed summary,
unrecognized crash, or real test failure remains failed. A failed simulator
restart stops recovery; a failed second attempt remains failed without another
retry. Parallel workers boot their own clones from the shut-down template;
single-worker recovery boots and waits for the selected simulator.

The retry retains every command argument, including test selectors and result
bundle path. The workflow still verifies the final result against its complete
test selection. Recovery does not change test assertions, selection, or timeout
limits.

Run the wrapper's regression tests locally with:

```sh
python3 -m unittest discover -s scripts/tests -p 'test_run_ui_tests.py' -v
```
