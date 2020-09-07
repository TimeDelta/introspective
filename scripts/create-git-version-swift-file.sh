#!/bin/bash
set -e

version=$(git rev-parse --verify HEAD | cut -c 1-7)
curdate=$(date +"%Y-%m-%d")

cd "`git rev-parse --show-toplevel`/Common/Common"
echo "//  DO NOT EDIT - GENERATED FILE" > GitVersion.swift
echo "//  GitVersion.swift" >> GitVersion.swift
echo "//  Created on $curdate." >> GitVersion.swift
echo "//" >> GitVersion.swift
echo "//" >> GitVersion.swift
echo "public let GIT_SHA_VERSION = \"$version\"" >> GitVersion.swift
uncommitted_changes="`git status --porcelain`"
if [[ -z $uncommitted_changes ]]; then
	echo "public let UNCOMMITTED_CHANGES = false" >> GitVersion.swift
else
	echo "public let UNCOMMITTED_CHANGES = true" >> GitVersion.swift
fi
touch GitVersion.swift
