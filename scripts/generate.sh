#!/bin/bash

cd ./packages/riverpod_analyzer_utils
dart pub run build_runner build --delete-conflicting-outputs
cd -

# Array to store background process IDs
pids=()

# Find all pubspec.yaml files and store them in an array
files=($(find . -type f -name "pubspec.yaml"))

# Loop through each file and run build_runner in parallel
for file in "${files[@]}"; do
    if [[ $file == *"riverpod_analyzer_utils"* ]]; then
        echo "Skipping $file"
        # skip as we already ran it
        continue
    fi
    if grep -q "build_runner" "$file"; then
        echo "Found build_runner in $file. Running build_runner..."
        dir=$(dirname "$file")
        (cd "$dir" && flutter pub run build_runner build -d) &
        pids+=($!)
    fi
done

# Wait for all background processes to complete
for pid in "${pids[@]}"; do
    wait "$pid"
done