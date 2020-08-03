part of '../state_notifier_provider.dart';

/// {@macro riverpod.statenotifierprovider}
class StateNotifierProvider<T extends StateNotifier<Object>>
    extends Provider<T> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    Create<T, ProviderReference> create, {
    String name,
  }) : super((ref) {
          final controller = create(ref);
          ref.onDispose(controller.dispose);
          return controller;
        }, name: name);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  StateNotifierStateProvider<Object> _state;
}

/// Adds [state] to [StateNotifierProvider.autoDispose].
extension StateNotifierStateProviderX<Value>
    on StateNotifierProvider<StateNotifier<Value>> {
  /// {@macro riverpod.statenotifierprovider.state.provider}
  StateNotifierStateProvider<Value> get state {
    _state ??= StateNotifierStateProvider<Value>._(this);
    return _state as StateNotifierStateProvider<Value>;
  }
}

/// {@template riverpod.statenotifierprovider.state.provider}
/// A provider that exposes the state of a [StateNotifier].
///
/// It is created by [StateNotifierProvider]
/// {@endtemplate}
class StateNotifierStateProvider<T>
    extends AlwaysAliveProviderBase<StateNotifier<T>, T> {
  StateNotifierStateProvider._(this._provider)
      : super(
          (ref) => ref.watch(_provider),
          _provider.name != null ? '${_provider.name}.state' : null,
        );

  final StateNotifierProvider<StateNotifier<T>> _provider;

  @override
  _StateNotifierStateProviderState<T> createState() {
    return _StateNotifierStateProviderState<T>();
  }

  @override
  Override overrideWithValue(T value) {
    return ProviderOverride(
      ValueProvider<StateNotifier<T>, T>((ref) {
        return ref.watch(_provider);
      }, value),
      this,
    );
  }
}

class _StateNotifierStateProviderState<T> = ProviderStateBase<StateNotifier<T>,
    T> with _StateNotifierStateProviderStateMixin<T>;

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [StateNotifierProvider] from an external parameter.
/// {@endtemplate}
class StateNotifierProviderFamily<T extends StateNotifier<Object>, A>
    extends Family<T, T, A, ProviderReference, StateNotifierProvider<T>> {
  /// {@macro riverpod.statenotifierprovider.family}
  StateNotifierProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  StateNotifierProvider<T> create(
    A value,
    T Function(ProviderReference ref, A param) builder,
    String name,
  ) {
    return StateNotifierProvider((ref) => builder(ref, value), name: name);
  }
}
