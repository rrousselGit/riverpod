import {
  riverpodVersion,
  riverpodAnnotationVersion,
  riverpodGeneratorVersion,
  riverpodLintVersion,
} from "../../../src/versions";

const codegen = `name: my_app_name
environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  riverpod: ^${riverpodVersion}
  riverpod_annotation: ^${riverpodAnnotationVersion}

dev_dependencies:
  build_runner:
  custom_lint:
  riverpod_generator: ^${riverpodGeneratorVersion}
  riverpod_lint: ^${riverpodLintVersion}
`;

const raw = `name: my_app_name
environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  riverpod: ^${riverpodVersion}

dev_dependencies:
  custom_lint:
  riverpod_lint: ^${riverpodLintVersion}
`;

export default {
  raw,
  hooks: raw,
  codegen,
  hooksCodegen: codegen,
};
