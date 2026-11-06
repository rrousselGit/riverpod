import {
  flutterRiverpodVersion,
  hooksRiverpodVersion,
  riverpodAnnotationVersion,
  riverpodGeneratorVersion,
  riverpodLintVersion,
} from "../../../../../../src/versions";

function plain(riverpod: string) {
  return `name: my_app_name
environment:
  sdk: ^3.12.0
  flutter: ">=3.44.0"

dependencies:
  flutter:
    sdk: flutter
  material_ui: ^1.0.0
  ${riverpod}

dev_dependencies:
  custom_lint:
  riverpod_lint: ^${riverpodLintVersion}
`;
}

function codegen(riverpod: string) {
  return `name: my_app_name
environment:
  sdk: ^3.12.0
  flutter: ">=3.44.0"

dependencies:
  flutter:
    sdk: flutter
  material_ui: ^1.0.0
  ${riverpod}
  riverpod_annotation: ^${riverpodAnnotationVersion}

dev_dependencies:
  build_runner:
  custom_lint:
  riverpod_generator: ^${riverpodGeneratorVersion}
  riverpod_lint: ^${riverpodLintVersion}
`;
}

export default {
  raw: plain(`flutter_riverpod: ^${flutterRiverpodVersion}`),
  hooks: plain(`hooks_riverpod: ^${hooksRiverpodVersion}\n  flutter_hooks:`),
  codegen: codegen(`flutter_riverpod: ^${flutterRiverpodVersion}`),
  hooksCodegen: codegen(`hooks_riverpod: ^${hooksRiverpodVersion}\n  flutter_hooks:`),
};
