import 'package:meta/meta.dart';

import '../framework.dart';
import 'builders.dart';
import 'deprecated/state_notifier_provider.dart' show StateNotifierProvider;
import 'stream_provider.dart' show StreamProvider;

part 'provider/auto_dispose.dart';
part 'provider/base.dart';

/// A base class for [Provider]
///
/// Not meant for public consumption
@internal
abstract class InternalProvider<State> extends ProviderBase<State> {
  /// A base class for [Provider]
  ///
  /// Not meant for public consumption
  const InternalProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.debugGetCreateSourceHash,
    required super.dependencies,
    required super.allTransitiveDependencies,
  });

  State _create(covariant ProviderElement<State> ref);

  /// Overrides a provider with a value, ejecting the default behavior.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified [dependencies], it will have no effect.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       myService.overrideWithValue(
  ///         // Replace the implementation of MyService with a fake implementation
  ///         MyFakeService(),
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  Override overrideWithValue(State value) {
    return ProviderOverride(
      origin: this,
      providerOverride: ValueProvider<State>(value),
    );
  }
}
