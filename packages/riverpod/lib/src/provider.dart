import 'package:meta/meta.dart';

import 'builders.dart';
import 'framework.dart';
import 'state_notifier_provider.dart' show StateNotifierProvider;
import 'stream_provider.dart' show StreamProvider;

part 'provider/auto_dispose.dart';
part 'provider/base.dart';

/// A base class for [Provider]
///
/// Not meant for public consumption
@internal
abstract class InternalProvider<State> extends ProviderBase<State>
    with OverrideWithValueMixin<State> {
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
}
