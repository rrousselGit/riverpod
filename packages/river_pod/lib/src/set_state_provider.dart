import 'dart:collection';

import 'common.dart';
import 'framework/framework.dart';

// This files contains the interfaces for all the variants of Provider.
// This is the public API.

/* Value */

class SetStateProviderValue<T> extends BaseProviderValue {
  SetStateProviderValue._(this._providerState);

  final BaseProviderState<SetStateProviderValue<T>, T,
      BaseProvider<SetStateProviderValue<T>, T>> _providerState;
  final _removeListeners = DoubleLinkedQueue<VoidCallback>();

  void watch(void Function(T value) listener) {
    _removeListeners.add(_providerState.$addStateListener(listener));
  }

  @override
  void dispose() {
    for (final listener in _removeListeners) {
      listener();
    }
  }
}

class SetStateProviderState<T> extends ProviderState {
  SetStateProviderState._(this._providerState) : super(_providerState);

  final BaseProviderState<SetStateProviderValue<T>, T,
      BaseProvider<SetStateProviderValue<T>, T>> _providerState;

  T get state => _providerState.$state;
  set state(T state) => _providerState.$state = state;
}

/* Providers */

class SetStateProvider<T>
    extends AlwaysAliveProvider<SetStateProviderValue<T>, T> {
  SetStateProvider(this._create);

  final Create<T, SetStateProviderState<T>> _create;

  @override
  _SetStateProviderState<T> createState() {
    return _SetStateProviderState<T>();
  }
}

class _SetStateProviderState<T> extends BaseProviderState<
    SetStateProviderValue<T>, T, SetStateProvider<T>> {
  @override
  T initState() {
    return provider._create(SetStateProviderState._(this));
  }

  @override
  SetStateProviderValue<T> createProviderValue() {
    return SetStateProviderValue._(this);
  }
}
