#!/bin/bash
set -eo pipefail

# DECRYPTION_KEY is an environment variable that must be set
if [[ -z "$DECRYPTION_KEY" ]]; then
	echo "Empty decryption key: must export DECRYPTION_KEY environment variable" >&2
	exit 1
fi

PROJECT_ROOT_DIR="`git rev-parse --show-toplevel`"

export OLD_IFS="$IFS"
export IFS=$'\n'

for file in `find "$PROJECT_ROOT_DIR/.github/secrets" -type f -iname \*.gpg -print`; do
	gpg --quiet --batch --yes --decrypt --passphrase="$DECRYPTION_KEY" --output "${file%.gpg}" "$file"
done

export IFS="$OLD_IFS"