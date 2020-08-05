#!/bin/bash
set -eo pipefail

PROVISIONING_PROFILES_DIR="~/Library/MobileDevice/Provisioning Profiles"
PROJECT_ROOT_DIR="`git rev-parse --show-toplevel`"
DECRYPTED_PROVISIONING_PROFILE="$PROJECT_ROOT_DIR/.github/secrets/Introspective_iOS_app.mobileprovision"
DECRYPTED_IOS_DISTRIBUTION_CERT="$PROJECT_ROOT_DIR/.github/secrets/ios_distribution.cer"

mkdir -p "$PROVISIONING_PROFILES_DIR"

cp "$PROVISIONING_PROFILE" "$PROVISIONING_PROFILES_DIR"

security create-keychain -p "" build.keychain
security import "$DECRYPTED_IOS_DISTRIBUTION_CERT" -t agg -k ~/Library/Keychains/build.keychain -P "" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain