export function buildDeps({
  deps = [],
  devDeps = [],
}: {
  deps?: string[];
  devDeps?: string[];
}) {
  var result = "";
  for (const dep of deps) {
    result += `dart pub add ${dep}\n`;
  }

  for (const dep of devDeps) {
    result += `dart pub add dev:${dep}\n`;
  }

  return result;
}

const raw = buildDeps({ deps: ["riverpod"] });

const codegen = buildDeps({
  deps: ["riverpod", "riverpod_annotation"],
  devDeps: ["riverpod_generator", "build_runner"],
});

export default {
  raw,
  hooks: undefined,
  codegen,
  hooksCodegen: undefined,
};
