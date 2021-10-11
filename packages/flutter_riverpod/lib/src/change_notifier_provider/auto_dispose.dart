part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
typedef AutoDisposeChangeNotifierProviderRef<Notifier>
    = AutoDisposeProviderRefBase;

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider}
@sealed
class AutoDisposeChangeNotifierProvider<Notifier extends ChangeNotifier>
    extends AutoDisposeProviderBase<Notifier>
    with ChangeNotifierProviderOverrideMixin<Notifier> {
  /// {@macro riverpod.changenotifierprovider}
  AutoDisposeChangeNotifierProvider(
    Create<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  })  : notifier = AutoDisposeProvider((ref) {
          final notifier = create(ref);
          ref.onDispose(notifier.dispose);

          return notifier;
        }, dependencies: dependencies),
        super(name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeChangeNotifierProviderFamilyBuilder();

  @override
  ProviderBase<Object?> get originProvider => notifier;

  /// {@macro flutter_riverpod.changenotifierprovider.notifier}
  @override
  final AutoDisposeProviderBase<Notifier> notifier;

  @override
  Notifier create(AutoDisposeProviderElementBase<Notifier> ref) {
    final notifier = ref.watch<Notifier>(this.notifier);
    _listenNotifier(notifier, ref);
    return notifier;
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;

  /// Overrides the behavior of a provider with a another provider.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeChangeNotifierProvider<Notifier> provider,
  ) {
    return ProviderOverride(
      origin: notifier,
      override: provider.notifier,
    );
  }

  @override
  AutoDisposeProviderElement<Notifier> createElement() =>
      AutoDisposeProviderElement(this);
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider.family}
@sealed
class AutoDisposeChangeNotifierProviderFamily<Notifier extends ChangeNotifier,
        Arg>
    extends Family<Notifier, Arg, AutoDisposeChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider.family}
  AutoDisposeChangeNotifierProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>,
      Arg> _create;

  @override
  AutoDisposeChangeNotifierProvider<Notifier> create(Arg argument) {
    final provider = AutoDisposeChangeNotifierProvider(
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
    AutoDisposeChangeNotifierProvider<Notifier> Function(Arg argument) override,
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
