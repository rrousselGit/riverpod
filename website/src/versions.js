import riverpodPubspec from "!!raw-loader!../../packages/riverpod/pubspec.yaml";
import flutterRiverpodPubspec from "!!raw-loader!../../packages/flutter_riverpod/pubspec.yaml";
import hooksRiverpodPubspec from "!!raw-loader!../../packages/hooks_riverpod/pubspec.yaml";
import riverpodAnnotationPubspec from "!!raw-loader!../../packages/riverpod_annotation/pubspec.yaml";
import riverpodGeneratorPubspec from "!!raw-loader!../../packages/riverpod_generator/pubspec.yaml";
import riverpodLintPubspec from "!!raw-loader!../../packages/riverpod_lint/pubspec.yaml";
import { parse } from "yaml";

export const riverpodVersion = parse(riverpodPubspec).version;
export const flutterRiverpodVersion = parse(flutterRiverpodPubspec).version;
export const hooksRiverpodVersion = parse(hooksRiverpodPubspec).version;
export const riverpodGeneratorVersion = parse(riverpodGeneratorPubspec).version;
export const riverpodAnnotationVersion = parse(riverpodAnnotationPubspec).version;
export const riverpodLintVersion = parse(riverpodLintPubspec).version;
