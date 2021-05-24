part of '../change_notifier_provider.dart';

/// {@macro riverpod.changenotifierprovider}
@sealed
class ChangeNotifierProvider<T extends ChangeNotifier>
    extends AlwaysAliveProviderBase<T> with ProviderOverridesMixin<T> {
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
  late final AlwaysAliveProviderBase<T> notifier =
      Provider((ref) => ref.watch(this));

  final Create<T, ProviderRefBase> _create;

  @override
  T create(ProviderRefBase ref) => _create(ref);

  @override
  Override overrideWithValue(T value) => _overrideWithValue(this, value);

  @override
  ProviderElement<T> createElement() => ProviderElement(this);

  @override
  bool recreateShouldNotify(T previousState, T newState) => true;
}

/// {@template riverpod.changenotifierprovider.family}
/// A class that allows building a [ChangeNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class ChangeNotifierProviderFamily<T extends ChangeNotifier, A>
    extends Family<T, A, ChangeNotifierProvider<T>> {
  /// {@macro riverpod.changenotifierprovider.family}
  ChangeNotifierProviderFamily(this._create, {String? name}) : super(name);

  final T Function(ProviderRefBase ref, A a) _create;

  @override
  ChangeNotifierProvider<T> create(A argument) {
    return ChangeNotifierProvider((ref) => _create(ref, argument), name: name);
  }
}
