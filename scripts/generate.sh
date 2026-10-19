#!/bin/bash
# Regenerates all generated code. Kept for muscle memory; see scripts/check.sh.
exec "$(dirname "$0")/check.sh" generate --fix "$@"
