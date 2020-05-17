import 'dart:collection';

import 'common.dart';
import 'framework/framework.dart';

class SetStateProviderSubscription<T> extends ProviderBaseSubscription {
  SetStateProviderSubscription._(this._providerState);

  final ProviderBaseState<SetStateProviderSubscription<T>, T,
      ProviderBase<SetStateProviderSubscription<T>, T>> _providerState;

  final _subscriptions = DoubleLinkedQueue<ProviderLink>();

  void watch(void Function(T value) listener) {
    // TODO change this
    final sub = _providerState.$subscribe((read) => listener(read()));
    _subscriptions.add(sub);
    listener(sub.read());
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.close();
    }
  }
}

class SetStateProviderReference<T> extends ProviderReference {
  SetStateProviderReference._(this._providerState) : super(_providerState);

  final _SetStateProviderState<T> _providerState;

  T get state => _providerState.state;
  set state(T state) => _providerState.state = state;
}

class SetStateProvider<T>
    extends AlwaysAliveProvider<SetStateProviderSubscription<T>, T> {
  SetStateProvider(this._create);

  final Create<T, SetStateProviderReference<T>> _create;

  @override
  _SetStateProviderState<T> createState() {
    return _SetStateProviderState<T>();
  }
}

class _SetStateProviderState<T> extends ProviderBaseState<
    SetStateProviderSubscription<T>, T, SetStateProvider<T>> {
  T _state;
  @override
  T get state => _state;
  set state(T state) {
    _state = state;
    $notifyListeners();
  }

  @override
  void initState() {
    _state = provider._create(SetStateProviderReference._(this));
  }

  @override
  SetStateProviderSubscription<T> createProviderSubscription() {
    return SetStateProviderSubscription._(this);
  }
}
