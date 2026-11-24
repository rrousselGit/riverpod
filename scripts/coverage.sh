#!/bin/bash
# Runs the tests of the package in the current directory with coverage.
# Arguments are passed to coverage:test_with_coverage.

# Fast fail the script on failures.
set -e
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

ensure_pub_global coverage coverage
dart pub global run coverage:test_with_coverage "$@"
