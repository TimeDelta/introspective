#!/bin/bash
set -eo pipefail

if [[ -z "$APPLE_ID_USERNAME" ]]; then
	echo "Must export APPLE_ID_USERNAME environment variable" >&2
	exit 1
fi

if [[ -z "$APPLE_ID_APP_PASSWORD" ]]; then
	echo "Must export APPLE_ID_APP_PASSWORD environment variable" >&2
	exit 1
fi

xcrun altool --upload-app -t ios -f build/Introspective.ipa -u "$APPLE_ID_USERNAME" -p "$APPLE_ID_APP_PASSWORD" --verbose
