export function buildDeps({
  deps = [],
  devDeps = [],
}: {
  deps?: string[];
  devDeps?: string[];
}) {
  var result = "dart pub add";
  for (const dep of deps) {
    result += ` \\\n  ${dep}`;
  }

  for (const dep of [...devDeps, "custom_lint", "riverpod_lint"]) {
    result += ` \\\n  dev:${dep}`;
  }

  return result;
}

const raw = buildDeps({ deps: ["riverpod"] });

const codegen = buildDeps({
  deps: ["riverpod"],
  devDeps: ["riverpod_generator", "build_runner"],
});

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
