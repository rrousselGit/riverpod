part of '../change_notifier_provider.dart';

/// {@macro riverpod.changenotifierprovider}
@sealed
class ChangeNotifierProvider<T extends ChangeNotifier>
    extends AlwaysAliveProviderBase<T, T> with ProviderOverridesMixin<T, T> {
  /// {@macro riverpod.changenotifierprovider}
  ChangeNotifierProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = ChangeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

  /// {@template flutter_riverpod.changenotifierprovider.notifier}
  /// Obtains the [ChangeNotifier] associated with this provider, but without
  /// listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [ChangeNotifier] it recreated.
  ///
  ///
  /// It is preferrable to do:
  /// ```dart
  /// ref.watch(changeNotifierProvider.notifier)
  /// ```
  ///
  /// instead of:
  /// ```dart
  /// ref.read(changeNotifierProvider)
  /// ```
  ///
  /// The reasoning is, using `read` could cause hard to catch bugs, such as
  /// not rebuilding dependent providers/widgets after using `context.refresh` on this provider.
  /// {@endtemplate}
  late final AlwaysAliveProviderBase<T, T> notifier =
      Provider((ref) => ref.watch(this));

  @override
  Override overrideWithValue(T value) => _overrideWithValue(this, value);

  final Create<T, ProviderReference> _create;

  @override
  T create(ProviderReference ref) => _create(ref);

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState();
}

@sealed
class _ChangeNotifierProviderState<
        T extends ChangeNotifier> = ProviderStateBase<T, T>
    with _ChangeNotifierProviderStateMixin<T>;

/// {@template riverpod.changenotifierprovider.family}
/// A class that allows building a [ChangeNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class ChangeNotifierProviderFamily<T extends ChangeNotifier, A>
    extends Family<T, T, A, ProviderReference, ChangeNotifierProvider<T>> {
  /// {@macro riverpod.changenotifierprovider.family}
  ChangeNotifierProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  ChangeNotifierProvider<T> create(
    A value,
    T Function(ProviderReference ref, A param) builder,
    String? name,
  ) {
    return ChangeNotifierProvider((ref) => builder(ref, value), name: name);
  }
}
