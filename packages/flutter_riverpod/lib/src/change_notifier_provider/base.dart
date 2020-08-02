part of '../change_notifier_provider.dart';

/// {@macro riverpod.changenotifierprovider}
class ChangeNotifierProvider<T extends ChangeNotifier>
    extends AlwaysAliveProviderBase<T, T> {
  /// {@macro riverpod.changenotifierprovider}
  ChangeNotifierProvider(
    Create<T, ProviderReference> create, {
    String name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = ChangeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState<
        T extends ChangeNotifier> = ProviderStateBase<T, T>
    with _ChangeNotifierProviderStateMixin<T>;

/// {@template riverpod.changenotifierprovider.family}
/// A class that allows building a [ChangeNotifierProvider] from an external parameter.
/// {@endtemplate}
class ChangeNotifierProviderFamily<T extends ChangeNotifier, A>
    extends Family<T, T, A, ProviderReference, ChangeNotifierProvider<T>> {
  /// {@macro riverpod.changenotifierprovider.family}
  ChangeNotifierProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  ChangeNotifierProvider<T> create(
    A value,
    T Function(ProviderReference ref, A param) builder,
    String name,
  ) {
    return ChangeNotifierProvider((ref) => builder(ref, value), name: name);
  }
}
