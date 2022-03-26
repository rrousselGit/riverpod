part of '../restorable_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeRestorableProviderRef<Notifier>
    implements AutoDisposeRef<Notifier> {
  /// The [RestorableProperty] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  Notifier get notifier;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.Restorablenotifierprovider}
@sealed
class AutoDisposeRestorableProvider<
        Notifier extends RestorableProperty<dynamic>?>
    extends AutoDisposeProviderBase<Notifier>
    with
        RestorableProviderOverrideMixin<Notifier>,
        OverrideWithProviderMixin<Notifier,
            AutoDisposeRestorableProvider<Notifier>> {
  /// {@macro riverpod.Restorablenotifierprovider}
  AutoDisposeRestorableProvider(
    Create<Notifier, AutoDisposeRestorableProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
    Duration? cacheTime,
    Duration? disposeDelay,
  })  : notifier = _AutoDisposeNotifierProvider<Notifier>(
          create,
          name: modifierName(name, 'notifier'),
          dependencies: dependencies,
          from: from,
          argument: argument,
          cacheTime: cacheTime,
        ),
        super(
          name: name,
          from: from,
          argument: argument,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  /// {@macro riverpod.family}
  static const family = AutoDisposeRestorableProviderFamilyBuilder();

  @override
  ProviderBase<Notifier> get originProvider => notifier;

  /// {@macro flutter_riverpod.Restorablenotifierprovider.notifier}
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
class _AutoDisposeNotifierProvider<
        Notifier extends RestorableProperty<dynamic>?>
    extends AutoDisposeProviderBase<Notifier> {
  _AutoDisposeNotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
    Family? from,
    Object? argument,
    Duration? cacheTime,
    Duration? disposeDelay,
  }) : super(
          name: modifierName(name, 'notifier'),
          from: from,
          argument: argument,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  @override
  final List<ProviderOrFamily>? dependencies;

  final Create<Notifier, AutoDisposeRestorableProviderRef<Notifier>> _create;

  @override
  Notifier create(
    covariant AutoDisposeRestorableProviderRef<Notifier> ref,
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

class _AutoDisposeNotifierProviderElement<
        Notifier extends RestorableProperty<dynamic>?>
    extends AutoDisposeProviderElementBase<Notifier>
    implements AutoDisposeRestorableProviderRef<Notifier> {
  _AutoDisposeNotifierProviderElement(
      _AutoDisposeNotifierProvider<Notifier> provider)
      : super(provider);

  @override
  Notifier get notifier => requireState;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.Restorablenotifierprovider.family}
@sealed
class AutoDisposeRestorableProviderFamily<
        Notifier extends RestorableProperty<dynamic>?, Arg>
    extends Family<Notifier, Arg, AutoDisposeRestorableProvider<Notifier>> {
  /// {@macro riverpod.Restorablenotifierprovider.family}
  AutoDisposeRestorableProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Duration? cacheTime,
    Duration? disposeDelay,
  }) : super(
          name: name,
          dependencies: dependencies,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  final FamilyCreate<Notifier, AutoDisposeRestorableProviderRef<Notifier>, Arg>
      _create;

  @override
  AutoDisposeRestorableProvider<Notifier> create(Arg argument) {
    return AutoDisposeRestorableProvider<Notifier>(
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
    AutoDisposeRestorableProvider<Notifier> Function(Arg argument) override,
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
