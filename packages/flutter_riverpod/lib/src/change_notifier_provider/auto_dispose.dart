part of '../change_notifier_provider.dart';

/// {@macro riverpod.changenotifierprovider}
@sealed
class AutoDisposeChangeNotifierProvider<T extends ChangeNotifier>
    extends AutoDisposeProviderBase<T, T> {
  /// {@macro riverpod.changenotifierprovider}
  AutoDisposeChangeNotifierProvider(
    Create<T, T, AutoDisposeProviderReference<T>> create, {
    String? name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = ChangeNotifierProviderFamilyBuilder();

  @override
  _AutoDisposeChangeNotifierProviderState<T> createState() =>
      _AutoDisposeChangeNotifierProviderState();
}

@sealed
class _AutoDisposeChangeNotifierProviderState<
        T extends ChangeNotifier> = ProviderStateBase<T, T>
    with _ChangeNotifierProviderStateMixin<T>;

/// {@macro riverpod.changenotifierprovider.family}
@sealed
class AutoDisposeChangeNotifierProviderFamily<T extends ChangeNotifier, A>
    extends Family<T, T, A, AutoDisposeProviderReference<T>,
        AutoDisposeChangeNotifierProvider<T>> {
  /// {@macro riverpod.changenotifierprovider.family}
  AutoDisposeChangeNotifierProviderFamily(
    T Function(AutoDisposeProviderReference<T> ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  AutoDisposeChangeNotifierProvider<T> create(
    A value,
    T Function(AutoDisposeProviderReference<T> ref, A param) builder,
    String? name,
  ) {
    return AutoDisposeChangeNotifierProvider(
      (ref) => builder(ref, value),
      name: name,
    );
  }
}
