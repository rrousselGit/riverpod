part of '../state_notifier_provider.dart';

/// {@macro riverpod.statenotifierprovider}
@sealed
class StateNotifierProvider<Notifier extends StateNotifier<Value>, Value>
    extends AlwaysAliveProviderBase<Notifier, Value> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    Create<Notifier, ProviderReference> create, {
    String? name,
  }) : super(create, name);

  // TODO name
  late final RootProvider<Notifier, Notifier> notifier = CreatedProvider(this);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  @override
  _StateNotifierProviderState<Notifier, Value> createState() {
    return _StateNotifierProviderState<Notifier, Value>();
  }
}

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [StateNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StateNotifierProviderFamily<Notifier extends StateNotifier<Value>, Value,
        Param>
    extends Family<Notifier, Value, Param, ProviderReference,
        StateNotifierProvider<Notifier, Value>> {
  /// {@macro riverpod.statenotifierprovider.family}
  StateNotifierProviderFamily(
    Notifier Function(ProviderReference ref, Param a) create, {
    String? name,
  }) : super(create, name);

  @override
  StateNotifierProvider<Notifier, Value> create(
    Param value,
    Notifier Function(ProviderReference ref, Param param) builder,
    String? name,
  ) {
    return StateNotifierProvider((ref) => builder(ref, value), name: name);
  }
}
