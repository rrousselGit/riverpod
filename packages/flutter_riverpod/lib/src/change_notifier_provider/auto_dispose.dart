part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeChangeNotifierProviderRef<Notifier>
    implements AutoDisposeRef {
  /// The [ChangeNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  Notifier get notifier;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider}
@sealed
class AutoDisposeChangeNotifierProvider<Notifier extends ChangeNotifier?>
    extends AutoDisposeProviderBase<Notifier>
    with
        ChangeNotifierProviderOverrideMixin<Notifier>,
        OverrideWithProviderMixin<Notifier,
            AutoDisposeChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider}
  AutoDisposeChangeNotifierProvider(
    Create<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
  })  : notifier = _AutoDisposeNotifierProvider<Notifier>(
          create,
          name: modifierName(name, 'notifier'),
          dependencies: dependencies,
          from: from,
          argument: argument,
        ),
        super(name: name, from: from, argument: argument);

  /// {@macro riverpod.family}
  static const family = AutoDisposeChangeNotifierProviderFamilyBuilder();

  @override
  ProviderBase<Notifier> get originProvider => notifier;

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
class _AutoDisposeNotifierProvider<Notifier extends ChangeNotifier?>
    extends AutoDisposeProviderBase<Notifier> {
  _AutoDisposeNotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
    Family? from,
    Object? argument,
  }) : super(
          name: modifierName(name, 'notifier'),
          from: from,
          argument: argument,
        );

  @override
  final List<ProviderOrFamily>? dependencies;

  final Create<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>>
      _create;

  @override
  Notifier create(
    covariant AutoDisposeChangeNotifierProviderRef<Notifier> ref,
  ) {
    final notifier = _create(ref);
    if (notifier != null) ref.onDispose(notifier.dispose);

    return notifier;
  }

  @override
  _AutoDisposeNotifierProviderElement<Notifier> createElement() {
    return _AutoDisposeNotifierProviderElement<Notifier>(this);
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

class _AutoDisposeNotifierProviderElement<Notifier extends ChangeNotifier?>
    extends AutoDisposeProviderElementBase<Notifier>
    implements AutoDisposeChangeNotifierProviderRef<Notifier> {
  _AutoDisposeNotifierProviderElement(
      _AutoDisposeNotifierProvider<Notifier> provider)
      : super(provider);

  @override
  Notifier get notifier => requireState;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider.family}
@sealed
class AutoDisposeChangeNotifierProviderFamily<Notifier extends ChangeNotifier?,
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
    return AutoDisposeChangeNotifierProvider<Notifier>(
      (ref) => _create(ref, argument),
      name: name,
      from: this,
      argument: argument,
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);

    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }

  /// {@endtemplate}
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
}
