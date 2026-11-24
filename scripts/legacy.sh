#!/usr/bin/env bash
# Checks that the legacy APIs (StateProvider, StateNotifierProvider,
# ChangeNotifierProvider, package:state_notifier and the legacy.dart
# libraries) are only used where baselines/legacy_api.yaml allows them.
#
# This covers what the avoid_legacy_api lint (run by scripts/analyze.sh)
# cannot see: pubspec.yaml, ```dart blocks of Markdown files, and the Dart
# files the analyzer skips. It also forbids silencing the lint, and fails on
# baseline entries that are no longer needed.
#
# Usage: scripts/legacy.sh

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

case "${1:-}" in
  "") ;;
  -h|--help) usage; exit 0 ;;
  *) die "unknown argument '$1' (see --help)" ;;
esac

ensure_deps
cd "$ROOT" || exit 1
exec dart run internal_lint:check_legacy_api "$ROOT"
