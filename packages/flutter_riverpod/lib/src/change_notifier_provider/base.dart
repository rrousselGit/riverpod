part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
typedef ChangeNotifierProviderRef<Notifier extends ChangeNotifier>
    = ProviderRefBase;

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider}
@sealed
class ChangeNotifierProvider<Notifier extends ChangeNotifier>
    extends AlwaysAliveProviderBase<Notifier> {
  /// {@macro riverpod.changenotifierprovider}
  ChangeNotifierProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = ChangeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

  final Create<Notifier, ChangeNotifierProviderRef<Notifier>> _create;

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
  late final AlwaysAliveProviderBase<Notifier> notifier = Provider((ref) {
    final notifier = _create(ref);
    ref.onDispose(notifier.dispose);

    return notifier;
  });

  @override
  Notifier create(ProviderElementBase<Notifier> ref) {
    final notifier = ref.watch<Notifier>(this.notifier);
    _listenNotifier(notifier, ref);
    return notifier;
  }

  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(Notifier value) {
    return ProviderOverride((setup) {
      setup(origin: this, override: this);
      setup(origin: notifier, override: ValueProvider<Notifier>(value));
    });
  }

  /// Overrides the behavior of a provider with a another provider.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    ChangeNotifierProvider<Notifier> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: this, override: this);
      setup(origin: notifier, override: provider.notifier);
    });
  }

  @override
  void setupOverride(SetupOverride setup) {
    setup(origin: this, override: this);
    setup(origin: notifier, override: notifier);
  }

  @override
  ProviderElement<Notifier> createElement() {
    return ProviderElement(this);
  }

  @override
  bool recreateShouldNotify(Notifier previousState, Notifier newState) => true;
}

/// {@template riverpod.changenotifierprovider.family}
/// A class that allows building a [ChangeNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class ChangeNotifierProviderFamily<Notifier extends ChangeNotifier, Arg>
    extends Family<Notifier, Arg, ChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider.family}
  ChangeNotifierProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<Notifier, ChangeNotifierProviderRef<Notifier>, Arg>
      _create;

  @override
  ChangeNotifierProvider<Notifier> create(Arg argument) {
    final provider = ChangeNotifierProvider(
      (ref) => _create(ref, argument),
      name: name,
    );

    registerProvider(provider.notifier, argument);

    return provider;
  }

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    ChangeNotifierProvider<Notifier> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(
      this,
      (arg, setup) {
        final provider = call(arg);

        setup(origin: provider.notifier, override: override(arg).notifier);
        setup(origin: provider, override: provider);
      },
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);

    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }
}
