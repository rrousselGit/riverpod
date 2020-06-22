import 'package:state_notifier/state_notifier.dart';

import 'common.dart';
import 'framework/framework.dart';
import 'provider/provider.dart';
import 'state_notifier_provider/state_notifier_provider.dart';

/// A [StateNotifier] that allows modifying its [state] from outside.
///
/// This avoids having to make a [StateNotifier] subclass for simple scenarios.
class StateController<T> extends StateNotifier<T> {
  /// Initialize the state of [StateController].
  StateController(T state) : super(state);

  // Remove the protected status
  @override
  T get state => super.state;

  @override
  set state(T value) => super.state = value;
}

/// A provider that expose a value which can be modified from outside.
///
/// Listening to this provider will trigger a rebuild when the value exposed
/// changed.
///
/// This is syntax sugar for [StateNotifierProvider] for simple values like enums
/// or booleans.
class StateProvider<T> extends AlwaysAliveProviderBase<ProviderDependencyBase,
    StateController<T>> {
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
    state = StateController(provider._create(ProviderReference(this)));
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

/// Creates a [StateProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class StateProviderFamily<Result, A> extends Family<StateProvider<Result>, A> {
  /// Creates a [StateProvider] from external parameters.
  StateProviderFamily(Result Function(ProviderReference ref, A a) create)
      : super((a) => StateProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) => StateProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
