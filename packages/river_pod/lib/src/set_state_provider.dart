import 'dart:collection';

import 'common.dart';
import 'framework/framework.dart';

class SetStateProviderSubscription<T> extends ProviderBaseSubscription {
  SetStateProviderSubscription._(this._providerState);

  final ProviderBaseState<SetStateProviderSubscription<T>, T,
      ProviderBase<SetStateProviderSubscription<T>, T>> _providerState;

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

class SetStateProviderContext<T> extends ProviderContext {
  SetStateProviderContext._(this._providerState) : super(_providerState);

  final ProviderBaseState<SetStateProviderSubscription<T>, T,
      ProviderBase<SetStateProviderSubscription<T>, T>> _providerState;

  T get state => _providerState.$state;
  set state(T state) => _providerState.$state = state;
}

class SetStateProvider<T>
    extends AlwaysAliveProvider<SetStateProviderSubscription<T>, T> {
  SetStateProvider(this._create);

  final Create<T, SetStateProviderContext<T>> _create;

  @override
  _SetStateProviderState<T> createState() {
    return _SetStateProviderState<T>();
  }
}

class _SetStateProviderState<T> extends ProviderBaseState<
    SetStateProviderSubscription<T>, T, SetStateProvider<T>> {
  @override
  T initState() {
    return provider._create(SetStateProviderContext._(this));
  }

  @override
  SetStateProviderSubscription<T> createProviderSubscription() {
    return SetStateProviderSubscription._(this);
  }
}
