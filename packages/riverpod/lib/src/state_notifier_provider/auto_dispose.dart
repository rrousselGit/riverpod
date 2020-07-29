part of '../state_notifier_provider.dart';

/// {@macro riverpod.statenotifierprovider}
class AutoDisposeStateNotifierProvider<T extends StateNotifier<Object>>
    extends AutoDisposeProvider<T> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(
    Create<T, AutoDisposeProviderReference> create, {
    String name,
  }) : super((ref) {
          final controller = create(ref);
          ref.onDispose(controller.dispose);
          return controller;
        }, name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamilyBuilder();

  AutoDisposeStateNotifierStateProvider<Object> _state;
}

/// Adds [state] to [StateNotifierProvider.autoDispose].
extension AutoDisposeStateNotifierStateProviderX<Value>
    on AutoDisposeStateNotifierProvider<StateNotifier<Value>> {
  /// {@macro riverpod.statenotifierprovider.state.provider}
  AutoDisposeStateNotifierStateProvider<Value> get state {
    _state ??= AutoDisposeStateNotifierStateProvider<Value>._(this);
    return _state as AutoDisposeStateNotifierStateProvider<Value>;
  }
}

/// {@macro riverpod.statenotifierprovider.state.provider}
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

class _AutoDisposeStateNotifierStateProviderState<T> = ProviderStateBase<
    StateNotifier<T>, T> with _StateNotifierStateProviderStateMixin<T>;

/// {@macro riverpod.statenotifierprovider.family}
class AutoDisposeStateNotifierProviderFamily<T extends StateNotifier<Object>, A>
    extends Family<T, T, A, AutoDisposeProviderReference,
        AutoDisposeStateNotifierProvider<T>> {
  /// {@macro riverpod.statenotifierprovider.family}
  AutoDisposeStateNotifierProviderFamily(
    T Function(AutoDisposeProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  AutoDisposeStateNotifierProvider<T> create(
    A value,
    T Function(AutoDisposeProviderReference ref, A param) builder,
    String name,
  ) {
    return AutoDisposeStateNotifierProvider((ref) => builder(ref, value),
        name: name);
  }
}
