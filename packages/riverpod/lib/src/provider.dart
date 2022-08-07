import 'package:meta/meta.dart';

import 'builders.dart';
import 'framework.dart';
import 'framework/family2.dart';

part 'provider/auto_dispose.dart';
part 'provider/base.dart';

abstract class _ProviderBase<State> extends ProviderBase<State> {
  /// {@macro riverpod.provider}
  _ProviderBase({
    required this.dependencies,
    required super.name,
    required super.from,
    required super.argument,
    required super.cacheTime,
    required super.disposeDelay,
  });

  // @override
  // ProviderBase<State> get originProvider => this;

  @override
  final List<ProviderOrFamily>? dependencies;

  State _create(covariant ProviderElement<State> ref);

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return previousState != newState;
  }
}
