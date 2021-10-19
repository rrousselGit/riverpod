part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
typedef AutoDisposeChangeNotifierProviderRef<Notifier> = AutoDisposeRef;

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

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);

    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }
}
