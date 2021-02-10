part of '../state_notifier_provider.dart';

/// {@macro riverpod.statenotifierprovider}
@sealed
class AutoDisposeStateNotifierProvider<T extends StateNotifier<Object?>>
    extends AutoDisposeProviderBase<T, T> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(
    Create<T, T, AutoDisposeProviderReference<T>> create, {
    String? name,
  }) : super((ref) => create(ref), name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamilyBuilder();

  AutoDisposeStateNotifierStateProvider<Object?>? _state;

  @override
  _AutoDisposeStateNotifierProviderState<T> createState() =>
      _AutoDisposeStateNotifierProviderState<T>();
}

@sealed
class _AutoDisposeStateNotifierProviderState<
        T extends StateNotifier<Object?>> = ProviderStateBase<T, T>
    with _StateNotifierProviderStateMixin<T>;

/// Adds [state] to [StateNotifierProvider.autoDispose].
extension AutoDisposeStateNotifierStateProviderX<Value>
    on AutoDisposeStateNotifierProvider<StateNotifier<Value>> {
  /// {@macro riverpod.statenotifierprovider.state.provider}
  AutoDisposeStateNotifierStateProvider<Value> get state {
    _state ??= AutoDisposeStateNotifierStateProvider<Value>._(this);
    // ignore: cast_nullable_to_non_nullable, confirmed to be non-null. This avoids one operation
    return _state as AutoDisposeStateNotifierStateProvider<Value>;
  }
}

/// {@macro riverpod.statenotifierprovider.state.provider}
@sealed
class AutoDisposeStateNotifierStateProvider<T>
    extends AutoDisposeProviderBase<StateNotifier<T>, T> {
  AutoDisposeStateNotifierStateProvider._(
      AutoDisposeStateNotifierProvider<StateNotifier<T>> provider)
      : super(
          (ref) => ref.watch(provider),
          provider.name != null ? '${provider.name}.state' : null,
        );

  @override
  _AutoDisposeStateNotifierStateProviderState<T> createState() {
    return _AutoDisposeStateNotifierStateProviderState<T>();
  }
}

@sealed
class _AutoDisposeStateNotifierStateProviderState<T> = ProviderStateBase<
    StateNotifier<T>, T> with _StateNotifierStateProviderStateMixin<T>;

/// {@macro riverpod.statenotifierprovider.family}
@sealed
class AutoDisposeStateNotifierProviderFamily<T extends StateNotifier<Object?>,
        A>
    extends Family<T, T, A, AutoDisposeProviderReference<T>,
        AutoDisposeStateNotifierProvider<T>> {
  /// {@macro riverpod.statenotifierprovider.family}
  AutoDisposeStateNotifierProviderFamily(
    T Function(AutoDisposeProviderReference<T> ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  AutoDisposeStateNotifierProvider<T> create(
    A value,
    T Function(AutoDisposeProviderReference<T> ref, A param) builder,
    String? name,
  ) {
    return AutoDisposeStateNotifierProvider<T>(
      (ref) => builder(ref, value),
      name: name,
    );
  }
}
