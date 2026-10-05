export function buildDeps({
  deps = [],
  devDeps = [],
}: {
  deps?: string[];
  devDeps?: string[];
}) {
  var result = '';
  for (const dep of deps) {
    result += `flutter pub add ${dep}\n`;
  }

  for (const dep of [...devDeps, "custom_lint", "riverpod_lint"]) {
    result += `flutter pub add dev:${dep}\n`;
  }

  return result;
}

const raw = buildDeps({ deps: ["material_ui", "flutter_riverpod"] });

const codegen = buildDeps({
  deps: ["material_ui", "flutter_riverpod", "riverpod_annotation"],
  devDeps: ["riverpod_generator", "build_runner"],
});

const hooks = buildDeps({ deps: ["material_ui", "hooks_riverpod", "flutter_hooks"] });

const hooksCodegen = buildDeps({
  deps: ["material_ui", "hooks_riverpod", "flutter_hooks", "riverpod_annotation"],
  devDeps: ["riverpod_generator", "build_runner"],
});

export default {
  raw: raw,
  hooks: hooks,
  codegen: codegen,
  hooksCodegen: hooksCodegen,
};
