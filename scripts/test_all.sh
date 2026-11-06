#!/usr/bin/env bash
# Runs the tests of every package CI tests, in parallel. Same options as
# scripts/test.sh.
exec "$(dirname "$0")/test.sh" "$@"
