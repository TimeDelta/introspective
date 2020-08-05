#!/bin/bash
set -eo pipefail

PROJECT_ROOT_DIR="`git rev-parse --show-toplevel`"

xcodebuild -archivePath "$PWD/build/Introspective.xcarchive" \
  -exportOptionsPlist "$PROJECT_ROOT_DIR/config/test-flight-options.plist" \
  -exportPath "$PWD/build" \
  -allowProvisioningUpdates \
  -exportArchive \
    | xcpretty
