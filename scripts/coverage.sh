#!/bin/bash

# Fast fail the script on failures.
set -e

dart pub global activate coverage

dart test --coverage="coverage"

format_coverage --packages=.packages -i coverage/test/** -l --out coverage.lcov