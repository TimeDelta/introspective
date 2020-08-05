#!/bin/bash
set -eo pipefail

WORKSPACE="`find . -type d -iname Introspective.xcworkspace`"

xcodebuild clean archive \
  -workspace "$WORKSPACE" \
  -scheme Release \
  -sdk iphoneos \
  -configuration AppStoreDistribution \
  -archivePath "$PWD/build/Introspective.xcarchive" \
    | xcpretty
