import riverpodPubspec from "!!raw-loader!../../packages/riverpod/pubspec.yaml";
import flutterRiverpodPubspec from "!!raw-loader!../../packages/flutter_riverpod/pubspec.yaml";
import hooksRiverpodPubspec from "!!raw-loader!../../packages/hooks_riverpod/pubspec.yaml";
import { parse } from "yaml";

export const riverpodVersion = `environment:
  sdk: ">=2.12.0-0 <3.0.0"

dependencies:
  riverpod: ^${parse(riverpodPubspec).version}
`;
export const flutterRiverpodVersion = `environment:
  sdk: ">=2.17.0 <3.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^${parse(flutterRiverpodPubspec).version}
`;
export const hooksRiverpodVersion = `environment:
  sdk: ">=2.17.0 <3.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_hooks: ^0.18.0
  hooks_riverpod: ^${parse(hooksRiverpodPubspec).version}
`;
