import {
  riverpodVersion,
  riverpodAnnotationVersion,
  riverpodGeneratorVersion,
} from "../../../src/versions";

const codegen = `name: my_app_name
environment:
  sdk: ^3.7.0

dependencies:
  riverpod: ^${riverpodVersion}
  riverpod_annotation: ^${riverpodAnnotationVersion}

dev_dependencies:
  build_runner:
  riverpod_generator: ^${riverpodGeneratorVersion}
`;

const raw = `name: my_app_name
environment:
  sdk: ^3.7.0

dependencies:
  riverpod: ^${riverpodVersion}
`;

export default {
  raw,
  hooks: undefined,
  codegen,
  hooksCodegen: undefined,
};
