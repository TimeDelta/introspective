#!/bin/bash
set -e

version=$(git rev-parse --verify HEAD | cut -c 1-7)
curdate=$(date +"%Y-%m-%d")

filesource="//  DO NOT EDIT - GENERATED FILE\n//  GitVersion.swift\n//  Created on $curdate.\n//\n\npublic let GIT_SHA_VERSION = \"$version\""

cd "`git rev-parse --show-toplevel`/Common/Common"
echo -e "$filesource" > GitVersion.swift
touch GitVersion.swift
