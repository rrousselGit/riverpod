part of '../state_notifier_provider.dart';

/// {@macro riverpod.statenotifierprovider}
@sealed
class AutoDisposeStateNotifierProvider<Notifier extends StateNotifier<Value>,
    Value> extends AutoDisposeProviderBase<Notifier, Value> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(
    Create<Notifier, AutoDisposeProviderReference> create, {
    String? name,
  }) : super(create, name);

  // TODO name
  late final RootProvider<Notifier, Notifier> notifier =
      AutoDisposeCreatedProvider(this);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamilyBuilder();

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
class AutoDisposeStateNotifierProviderFamily<
        Notifier extends StateNotifier<Value>, Value, Param>
    extends Family<Notifier, Value, Param, AutoDisposeProviderReference,
        AutoDisposeStateNotifierProvider<Notifier, Value>> {
  /// {@macro riverpod.statenotifierprovider.family}
  AutoDisposeStateNotifierProviderFamily(
    Notifier Function(AutoDisposeProviderReference ref, Param a) create, {
    String? name,
  }) : super(create, name);

  @override
  AutoDisposeStateNotifierProvider<Notifier, Value> create(
    Param value,
    Notifier Function(AutoDisposeProviderReference ref, Param param) builder,
    String? name,
  ) {
    return AutoDisposeStateNotifierProvider(
      (ref) => builder(ref, value),
      name: name,
    );
  }
}
