// DO NOT MOVE/RENAME

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// {@template riverpod_annotation.provider}
/// An annotation placed on classes or functions.
///
/// This tells riverpod_generator to generate a provider out of the annotated
/// element.
/// {@endtemplate}
@Target({TargetKind.classType, TargetKind.function})
@sealed
class Riverpod {
  /// {@macro riverpod_annotation.provider}
  const Riverpod({
    this.keepAlive = false,
    this.dependencies,
  });

  /// Whether the state of the provider should be maintained if it is no-longer used.
  ///
  /// Defaults to false.
  final bool keepAlive;

  /// The list of dependencies of a provider.
  ///
  /// Values passed to the list of dependency should be the classes/functions
  /// annotated with `@riverpod`; not the provider.
  final List<Object>? dependencies;
}

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();

/// An annotation used to help the linter find the user-defined element from
/// the generated provider.
///
/// DO NOT USE
class ProviderFor {
  /// An annotation used to help the linter find the user-defined element from
  /// the generated provider.
  // Put the annotation on the constructor to avoid the linter from complaining
  // about the annotation being exported; while preventing the user from using it.
  @internal
  const ProviderFor(this.value)
      : assert(
          value is Function || value is Type,
          '$value is not a class/function',
        );

  /// The code annotated by `@riverpod`
  final Object value;
}
