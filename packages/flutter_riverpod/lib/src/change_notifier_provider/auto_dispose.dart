part of '../change_notifier_provider.dart';

typedef AutoDisposeChangeNotifierProviderRef<Notifier>
    = AutoDisposeProviderRefBase;

/// {@macro riverpod.changenotifierprovider}
@sealed
class AutoDisposeChangeNotifierProvider<Notifier extends ChangeNotifier>
    extends AutoDisposeProviderBase<Notifier>
    implements AutoDisposeProviderOverridesMixin<Notifier> {
  /// {@macro riverpod.changenotifierprovider}
  AutoDisposeChangeNotifierProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeChangeNotifierProviderFamilyBuilder();

  final Create<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>>
      _create;

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
  late final AutoDisposeProviderBase<Notifier> notifier =
      AutoDisposeProvider((ref) {
    final notifier = _create(ref);
    ref.onDispose(notifier.dispose);

    return notifier;
  });

  @override
  Notifier create(AutoDisposeProviderElementBase<Notifier> ref) {
    final notifier = ref.watch<Notifier>(this.notifier);
    _listenNotifier(notifier, ref);
    return notifier;
  }

  @override
  Override overrideWithValue(Notifier value) {
    return ProviderOverride(
      ValueProvider<Notifier>((_) => value, value),
      notifier,
    );
  }

  @override
  Override overrideWithProvider(
    AutoDisposeProviderBase<Notifier> provider,
  ) {
    return ProviderOverride(provider, notifier);
  }

  @override
  AutoDisposeProviderElement<Notifier> createElement() =>
      AutoDisposeProviderElement(this);

  @override
  bool recreateShouldNotify(Notifier previousState, Notifier newState) => true;
}

/// {@template riverpod.changenotifierprovider.family}
/// A class that allows building a [ChangeNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class AutoDisposeChangeNotifierProviderFamily<Notifier extends ChangeNotifier,
        Arg>
    extends Family<Notifier, Arg, AutoDisposeChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider.family}
  AutoDisposeChangeNotifierProviderFamily(this._create, {String? name})
      : super(name);

  final FamilyCreate<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>,
      Arg> _create;

  @override
  AutoDisposeChangeNotifierProvider<Notifier> create(Arg argument) {
    return AutoDisposeChangeNotifierProvider(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}

/// An extension that adds [overrideWithProvider] to [Family].
extension XAutoDisposeChangeNotifierFamily<Notifier extends ChangeNotifier, Arg,
        FamilyProvider extends AutoDisposeProviderBase<Notifier>>
    on Family<Notifier, Arg, FamilyProvider> {
  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeProviderBase<Notifier> Function(Arg argument) override,
  ) {
    return FamilyOverride(
      this,
      (arg, provider) {
        if (provider is! ChangeNotifierProvider<Notifier>) {
          // .notifier isn't ChangeNotifierProvider
          return override(arg as Arg);
        }
        return provider;
      },
    );
  }
}
