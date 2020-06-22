import '../common.dart';
import '../framework/framework.dart';

import 'set_state_provider.dart';

// Implementation detail of StateNotifierProvider.

/// Manages a piece of state that can change over time.
class _SetStateProviderReference<T> extends AutoDisposeProviderReference
    implements SetStateProviderReference<T> {
  _SetStateProviderReference._(this._providerState) : super(_providerState);

  final _AutoDisposeSetStateProviderState<T> _providerState;

  /// The value currently exposed
  ///
  /// Modifying this value will notify all listeners.
  @override
  T get state => _providerState.state;

  @override
  set state(T newState) => _providerState.state = newState;
}

/// A provider that expose a value which can change over time
class AutoDisposeSetStateProvider<T>
    extends AutoDisposeProviderBase<ProviderDependencyBase, T> {
  /// A provider that expose a value which can change over time
  AutoDisposeSetStateProvider(this._create, {String name}) : super(name);

  final Create<T, _SetStateProviderReference<T>> _create;

  @override
  _AutoDisposeSetStateProviderState<T> createState() {
    return _AutoDisposeSetStateProviderState<T>();
  }
}

class _AutoDisposeSetStateProviderState<T> extends AutoDisposeProviderStateBase<
    ProviderDependencyBase, T, AutoDisposeSetStateProvider<T>> {
  T _state;
  @override
  T get state => _state;
  set state(T state) {
    _state = state;
    markMayHaveChanged();
  }

  @override
  void initState() {
    _state = provider._create(_SetStateProviderReference._(this));
  }

  @override
  ProviderDependencyBase createProviderDependency() {
    return ProviderBaseDependencyImpl();
  }
}
