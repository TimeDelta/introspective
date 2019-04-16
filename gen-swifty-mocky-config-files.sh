#!/bin/bash
PROJECT_DIR="`git rev-parse --show-toplevel`"
PROJECT_NAME="`basename "${PROJECT_DIR}"`"
INPUT_DIR="${PROJECT_DIR}/${PROJECT_NAME}"
NORMAL_MOCKS_FILE="${INPUT_DIR}Tests/Mocks.swift"
echo "Mocks Input Directory = ${INPUT_DIR}"

addArgs() {
    echo "args:" >> "$1"
    echo "  testable:" >> "$1"
    echo "    - Introspective" >> "$1"
    echo "  import:" >> "$1"
    echo "    - HealthKit" >> "$1"
    echo "    - CoreData" >> "$1"
    echo "    - Presentr" >> "$1"
    echo "    - CSV" >> "$1"
    echo "    - SwiftDate" >> "$1"
    echo "    - UserNotifications" >> "$1"
    echo "  excludedSwiftLintRules:" >> "$1"
    echo "    - force_cast" >> "$1"
    echo "    - function_body_length" >> "$1"
    echo "    - line_length" >> "$1"
    echo "    - vertical_whitespace" >> "$1"
}

EXCLUSION_PATTERN="Delegate|\
ViewController|\
Mock|\
DateExtension"

OLD_IFS="$IFS"
export IFS=$'\n'

CONFIG_FILE="${PROJECT_DIR}/mocky.yml"

echo "sources:" > "$CONFIG_FILE"
echo "  - ${INPUT_DIR}Tests/CustomMocks" >> "$CONFIG_FILE"
for file in `find "${INPUT_DIR}" -type f -name \*.swift | grep -v Carthage | egrep -v "${EXCLUSION_PATTERN}"`; do
    echo "  - $file" >> "$CONFIG_FILE"
done

echo "templates:" >> "$CONFIG_FILE"
echo "  - $PROJECT_DIR/Pods/SwiftyMocky/Sources/Templates" >> "$CONFIG_FILE"
echo "output:" >> "$CONFIG_FILE"
echo "  $NORMAL_MOCKS_FILE" >> "$CONFIG_FILE"

addArgs "$CONFIG_FILE"

echo "Done creating config files"

export IFS="$OLD_IFS"
