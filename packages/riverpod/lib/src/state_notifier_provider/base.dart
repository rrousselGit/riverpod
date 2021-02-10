part of '../state_notifier_provider.dart';

/// {@macro riverpod.statenotifierprovider}
@sealed
class StateNotifierProvider<T extends StateNotifier<Object?>>
    extends AlwaysAliveProviderBase<T, T> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    Create<T, T, ProviderReference<T>> create, {
    String? name,
  }) : super((ref) => create(ref), name);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  StateNotifierStateProvider<Object?>? _state;

  @override
  _StateNotifierProviderState<T> createState() =>
      _StateNotifierProviderState<T>();
}

@sealed
class _StateNotifierProviderState<
        T extends StateNotifier<Object?>> = ProviderStateBase<T, T>
    with _StateNotifierProviderStateMixin<T>;

/// Adds [state] to [StateNotifierProvider.autoDispose].
extension StateNotifierStateProviderX<Value>
    on StateNotifierProvider<StateNotifier<Value>> {
  /// {@macro riverpod.statenotifierprovider.state.provider}
  StateNotifierStateProvider<Value> get state {
    _state ??= StateNotifierStateProvider<Value>._(this);
    // ignore: cast_nullable_to_non_nullable, confirmed to be non-null. This avoids one operation
    return _state as StateNotifierStateProvider<Value>;
  }
}

/// {@template riverpod.statenotifierprovider.state.provider}
/// A provider that exposes the state of a [StateNotifier].
///
/// It is created by [StateNotifierProvider]
/// {@endtemplate}
@sealed
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

@sealed
class _StateNotifierStateProviderState<T> = ProviderStateBase<StateNotifier<T>,
    T> with _StateNotifierStateProviderStateMixin<T>;

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [StateNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StateNotifierProviderFamily<T extends StateNotifier<Object?>, A>
    extends Family<T, T, A, ProviderReference<T>, StateNotifierProvider<T>> {
  /// {@macro riverpod.statenotifierprovider.family}
  StateNotifierProviderFamily(
    T Function(ProviderReference<T> ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  StateNotifierProvider<T> create(
    A value,
    T Function(ProviderReference<T> ref, A param) builder,
    String? name,
  ) {
    return StateNotifierProvider((ref) => builder(ref, value), name: name);
  }
}
