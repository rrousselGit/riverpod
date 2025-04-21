if ! grep -q publish_to "pubspec.yaml"; then
  dart doc --dry-run
fi