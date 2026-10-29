#!/usr/bin/env bash
set -euo pipefail

git_version_script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
git_version_root=$(git -C "$git_version_script_dir" rev-parse --show-toplevel)
git_version_sha=$(git -C "$git_version_root" rev-parse --verify HEAD)
git_version_date=$(git -C "$git_version_root" log -1 --format=%cs)
git_version_status=$(git -C "$git_version_root" status --porcelain --untracked-files=no)
git_version_dirty=false
if [[ -n "$git_version_status" ]]; then git_version_dirty=true; fi

git_version_target="$git_version_root/Common/Common/GitVersion.swift"
git_version_temp=$(mktemp "$git_version_root/Common/Common/.GitVersion.XXXXXX")
trap 'rm -f "$git_version_temp"' EXIT
{
  printf '// DO NOT EDIT - GENERATED FILE\n// GitVersion.swift\n// Source commit dated %s.\n\n' "$git_version_date"
  printf 'public let GIT_SHA_VERSION = "%s"\n' "${git_version_sha:0:7}"
  printf 'public let UNCOMMITTED_CHANGES = %s\n' "$git_version_dirty"
} > "$git_version_temp"
# The workflow and the app build phase both call this. Preserve the timestamp
# when content is identical so a second invocation does not invalidate Common.
if ! cmp -s "$git_version_temp" "$git_version_target"; then
  mv "$git_version_temp" "$git_version_target"
fi
