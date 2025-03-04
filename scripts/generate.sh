#!/bin/bash

# Array to store background process IDs
pids=()

# Find all pubspec.yaml files and store them in an array
files=($(find . -type f -name "pubspec.yaml"))

# Loop through each file and run build_runner in parallel
for file in "${files[@]}"; do
    if grep -q "build_runner" "$file"; then
        echo "Found build_runner in $file. Running build_runner..."
        dir=$(dirname "$file")
        (cd "$dir" && flutter pub run build_runner build -d) &
        pids+=($!)
    else
        echo "build_runner not found in $file. Skipping build."
    fi
done

# Wait for all background processes to complete
for pid in "${pids[@]}"; do
    wait "$pid"
done
