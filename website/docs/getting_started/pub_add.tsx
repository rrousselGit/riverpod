const raw = `
flutter pub add \
  flutter_riverpod \
  dev:custom_lint \
  dev:riverpod_lint`;

const codegen = `
flutter pub add \
  flutter_riverpod \
  riverpod_annotation \
  dev:riverpod_generator \
  dev:custom_lint \
  dev:riverpod_lint \
  dev:build_runner`;

const hooks = `
flutter pub add \
  hooks_riverpod \
  flutter_hooks \
  dev:custom_lint \
  dev:riverpod_lint`;

const hooksCodegen = `
flutter pub add \
  hooks_riverpod \
  riverpod_annotation \
  flutter_hooks \
  dev:riverpod_generator \
  dev:custom_lint \
  dev:riverpod_lint \
  dev:build_runner`;

export default {
  raw: raw,
  hooks: hooks,
  codegen: codegen,
  hooksCodegen: hooksCodegen,
};
