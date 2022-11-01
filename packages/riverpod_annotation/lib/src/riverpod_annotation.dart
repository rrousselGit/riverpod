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
  /// Use the function name or class name of generated providers.
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
  /// @Riverpod(dependencies: ['myProvider', PublicClass])
  /// String dependant(DependantProviderRef ref) {
  ///   return '${ref.watch(publicClassProvider)} ${ref.watch(myProvider)}';
  /// }
  /// ```
  final List<Object>? dependencies;
}

/// {@macro riverpod_annotation.provider}
@Target({TargetKind.classType, TargetKind.function})
const riverpod = Riverpod();
