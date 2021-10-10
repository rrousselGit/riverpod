part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
typedef ChangeNotifierProviderRef<Notifier extends ChangeNotifier>
    = ProviderRefBase;

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider}
@sealed
class ChangeNotifierProvider<Notifier extends ChangeNotifier>
    extends AlwaysAliveProviderBase<Notifier>
    with ChangeNotifierProviderOverrideMixin<Notifier> {
  /// {@macro riverpod.changenotifierprovider}
  ChangeNotifierProvider(
    Create<Notifier, ChangeNotifierProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  })  : notifier = Provider((ref) {
          final notifier = create(ref);
          ref.onDispose(notifier.dispose);

          return notifier;
        }, dependencies: dependencies),
        super(name: name);

  /// {@macro riverpod.family}
  static const family = ChangeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

  @override
  ProviderBase<Object?> get originProvider => notifier;

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
  @override
  final AlwaysAliveProviderBase<Notifier> notifier;

  @override
  Notifier create(ProviderElementBase<Notifier> ref) {
    final notifier = ref.watch<Notifier>(this.notifier);
    _listenNotifier(notifier, ref);
    return notifier;
  }

  @override
  ProviderElement<Notifier> createElement() {
    return ProviderElement(this);
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

// ignore: subtype_of_sealed_class
/// {@template riverpod.changenotifierprovider.family}
/// A class that allows building a [ChangeNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class ChangeNotifierProviderFamily<Notifier extends ChangeNotifier, Arg>
    extends Family<Notifier, Arg, ChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider.family}
  ChangeNotifierProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

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

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);

    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }
}
