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
  const Riverpod({this.keepAlive = false, this.dependencies});

  /// Whether the state of the provider should be maintained if it is no-longer used.
  ///
  /// Defaults to false.
  final bool keepAlive;

  /// A list of the providers that this provider depends on.
  ///
  /// Values can either be a function or class annotated by `@riverpod`, or a Symbol
  /// representing the variable name of a provider.
  ///
  /// Example:
  /// ```dart
  /// final myProvider = Provider((ref) => 0);
  ///
  /// @riverpod
  /// String myGenerated(MyGeneratedProviderRef ref) => '';
  ///
  /// @Riverpod(dependencies: [myGenerated])
  /// class PublicClass extends _$PublicClass {
  ///   @override
  ///   String build() {
  ///     return 'Hello world ${ref.watch(myGeneratedProvider)}';
  ///   }
  /// }
  ///
  /// @Riverpod(dependencies: [#myProvider, PublicClass])
  /// String dependant(DependantProviderRef ref) {
  ///   return '${ref.watch(publicClassProvider)} ${ref.watch(myProvider)}';
  /// }
  /// ```
  ///
  ///
  /// **Note**:
  /// When specifying providers using a String, the provider variable must:
  /// - not be coming from any import alias
  /// - be a top-level variable (so no `MyClass.provider`)
  final List<Object>? dependencies;
}

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();
