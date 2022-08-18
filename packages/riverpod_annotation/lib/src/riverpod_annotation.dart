// DO NOT MOVE/RENAME

import 'package:meta/meta_meta.dart';

/// {@template riverpod_annotation.provider}
/// An annotation placed on classes or functions.
///
/// This tells riverpod_generator to generate a provider out of the annotated
/// element.
/// {@endtemplate}
@Target({TargetKind.classType, TargetKind.function})
class Riverpod {
  /// {@macro riverpod_annotation.provider}
  const Riverpod();
}

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();
