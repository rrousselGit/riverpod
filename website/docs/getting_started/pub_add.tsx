const raw = "flutter pub add flutter_riverpod dev:custom_lint dev:riverpod_lint";

const codegen = "flutter pub add flutter_riverpod dev:custom_lint dev:riverpod_lint riverpod_annotation dev:build_runner dev:riverpod_generator";

const hooks = "flutter pub add hooks_riverpod dev:custom_lint dev:riverpod_lint";

const hooksCodegen = "flutter pub add hooks_riverpod dev:custom_lint dev:riverpod_lint riverpod_annotation dev:build_runner dev:riverpod_generator";

export default {
    raw: raw,
    hooks: hooks,
    codegen: codegen,
    hooksCodegen: hooksCodegen
};
