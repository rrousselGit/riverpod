import 'package:meta/meta.dart';

import 'internals.dart';
import 'state_controller.dart';

part 'state_provider/auto_dispose.dart';
part 'state_provider/base.dart';

ProviderElementProxy<T, StateController<T>> _notifier<T>(
  _StateProviderBase<T> that,
) {
  return ProviderElementProxy<T, StateController<T>>(
    that,
    (element) {
      return (element as StateProviderElement<T>)._controllerNotifier;
    },
  );
}

ProviderElementProxy<T, StateController<T>> _state<T>(
  _StateProviderBase<T> that,
) {
  return ProviderElementProxy<T, StateController<T>>(
    that,
    (element) {
      return (element as StateProviderElement<T>)._stateNotifier;
    },
  );
}

abstract class _StateProviderBase<T> extends ProviderBase<T> {
  const _StateProviderBase({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  });

  ProviderListenable<StateController<T>> get notifier;
  ProviderListenable<StateController<T>> get state;

  T _create(covariant StateProviderElement<T> ref);
}
