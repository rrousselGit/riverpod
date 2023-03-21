const raw = `dart pub add riverpod dev:custom_lint dev:riverpod_lint`;

const codegen = `dart pub add riverpod dev:custom_lint dev:riverpod_lint riverpod_annotation dev:build_runner dev:riverpod_generator`;

export default {
    raw,
    hooks: raw,
    codegen,
    hooksCodegen: codegen,
};
