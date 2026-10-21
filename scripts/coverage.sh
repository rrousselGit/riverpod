#!/bin/bash
# Runs the tests of the package in the current directory with coverage.
# A package named x_tests holds the tests of package x, so its coverage is
# that of x.

# Fast fail the script on failures.
set -e
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

name="$(basename "$PWD")"
scope=""
[[ "$name" == *_tests ]] && scope="--scope-output=${name%_tests}"

ensure_pub_global coverage coverage
# shellcheck disable=SC2086 # $scope is empty or a single flag
dart pub global run coverage:test_with_coverage $scope
