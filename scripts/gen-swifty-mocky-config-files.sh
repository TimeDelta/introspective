#!/bin/bash
set -e

PROJECT_DIR="`git rev-parse --show-toplevel`"
PROJECT_NAME="Introspective"
OUTPUT_DIR="${PROJECT_DIR}/${PROJECT_NAME}Tests"
NORMAL_MOCKS_FILE="${OUTPUT_DIR}/Mocks.swift"

addImports() {
    echo "  testable:" >> "$1"
    echo "    - Introspective" >> "$1"
    echo "    - AttributeRestrictions" >> "$1"
    echo "    - Attributes" >> "$1"
    echo "    - BooleanAlgebra" >> "$1"
    echo "    - Common" >> "$1"
    echo "    - DataExport" >> "$1"
    echo "    - DataImport" >> "$1"
    echo "    - DependencyInjection" >> "$1"
    echo "    - Notifications" >> "$1"
    echo "    - Persistence" >> "$1"
    echo "    - Queries" >> "$1"
    echo "    - SampleGroupers" >> "$1"
    echo "    - SampleGroupInformation" >> "$1"
    echo "    - Samples" >> "$1"
    echo "    - Settings" >> "$1"
    echo "    - UIExtensions" >> "$1"
    echo "  import:" >> "$1"
    echo "    - HealthKit" >> "$1"
    echo "    - CoreData" >> "$1"
    echo "    - Presentr" >> "$1"
    echo "    - CSV" >> "$1"
    echo "    - SwiftDate" >> "$1"
    echo "    - UserNotifications" >> "$1"
    echo "    - Instructions" >> "$1"
}

EXCLUSION_PATTERN="Delegate|\
Mock|\
DateExtension|\
IntrospectiveTests"

OLD_IFS="$IFS"
export IFS=$'\n'

CONFIG_FILE="${PROJECT_DIR}/Mockfile"

echo "sourceryCommand: null" > "$CONFIG_FILE"
echo "sourceryTemplate: null" >> "$CONFIG_FILE"
echo >> "$CONFIG_FILE"
echo "IntrospectiveTests:" >> "$CONFIG_FILE"
echo "  sources:" >> "$CONFIG_FILE"
echo "    include:" >> "$CONFIG_FILE"
echo "      - ./${OUTPUT_DIR#${PROJECT_DIR}/}/CustomMocks" >> "$CONFIG_FILE"
for file in `find "${PROJECT_DIR}" -type f -name \*.swift | grep -v "/Pods/" | grep -v Carthage | egrep -v "${EXCLUSION_PATTERN}"`; do
    echo "      - ./${file#${PROJECT_DIR}/}" >> "$CONFIG_FILE"
done

echo "  output: ./${NORMAL_MOCKS_FILE#${PROJECT_DIR}/}" >> "$CONFIG_FILE"

echo "  targets:" >> "$CONFIG_FILE"
echo "    - IntrospectiveTests" >> "$CONFIG_FILE"

addImports "$CONFIG_FILE"

echo "Done creating $CONFIG_FILE"

export IFS="$OLD_IFS"
