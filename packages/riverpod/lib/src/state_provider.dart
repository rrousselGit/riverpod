import 'package:riverpod/src/provider.dart';
import 'package:state_notifier/state_notifier.dart';

import 'common.dart';
import 'framework/framework.dart';
import 'state_notifier_provider.dart';

class StateController<T> extends StateNotifier<T> {
  StateController._(T state) : super(state);

  // Remove the protected status
  @override
  T get state => super.state;

  @override
  set state(T value) {
    if (value != state) {
      super.state = value;
    }
  }
}

/// A provider that expose a value which can be modified from outside.
///
/// Listening to this provider will trigger a rebuild when the value exposed
/// changed.
///
/// This is syntax sugar for [StateNotifierProvider] for simple values like enums
/// or booleans.
class StateProvider<T>
    extends AlwaysAliveProvider<ProviderDependencyBase, StateController<T>> {
  /// Creates the initial value
  StateProvider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  _ProviderState<T> createState() => _ProviderState();
}

class _ProviderState<T> extends ProviderStateBase<ProviderDependencyBase,
    StateController<T>, StateProvider<T>> {
  @override
  StateController<T> state;
  VoidCallback _removeListener;

  @override
  void initState() {
    state = StateController._(provider._create(ProviderReference(this)));
    _removeListener = state.addListener((_) => markMayHaveChanged());
  }

  @override
  ProviderDependencyBase createProviderDependency() {
    return ProviderBaseDependencyImpl();
  }

  @override
  void dispose() {
    _removeListener();
    state.dispose();
    super.dispose();
  }
}
