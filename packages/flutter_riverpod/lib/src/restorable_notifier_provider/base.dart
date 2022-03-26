part of '../restorable_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class RestorableProviderRef<
    Notifier extends RestorableProperty<dynamic>?> implements Ref<Notifier> {
  /// The [RestorableProperty] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  Notifier get notifier;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.Restorablenotifierprovider}
@sealed
class RestorableProvider<Notifier extends RestorableProperty<dynamic>?>
    extends AlwaysAliveProviderBase<Notifier>
    with
        RestorableProviderOverrideMixin<Notifier>,
        OverrideWithProviderMixin<Notifier, RestorableProvider<Notifier>> {
  /// {@macro riverpod.Restorablenotifierprovider}
  RestorableProvider(
    Create<Notifier, RestorableProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
  })  : notifier = _NotifierProvider<Notifier>(
          create,
          name: name,
          dependencies: dependencies,
          from: from,
          argument: argument,
        ),
        super(name: name, from: from, argument: argument);

  /// {@macro riverpod.family}
  static const family = RestorableProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeRestorableProviderBuilder();

  @override
  ProviderBase<Notifier> get originProvider => notifier;

  /// {@template flutter_riverpod.Restorablenotifierprovider.notifier}
  /// Obtains the [RestorableProperty] associated with this provider, but without
  /// listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [RestorableProperty] it recreated.
  ///
  ///
  /// It is preferrable to do:
  /// ```dart
  /// ref.watch(RestorableProvider.notifier)
  /// ```
  ///
  /// instead of:
  /// ```dart
  /// ref.read(RestorableProvider)
  /// ```
  ///
  /// The reasoning is, using `read` could cause hard to catch bugs, such as
  /// not rebuilding dependent providers/widgets after using `ref.refresh` on this provider.
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
class _NotifierProvider<Notifier extends RestorableProperty<dynamic>?>
    extends AlwaysAliveProviderBase<Notifier> {
  _NotifierProvider(
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

  final Create<Notifier, RestorableProviderRef<Notifier>> _create;

  @override
  Notifier create(covariant RestorableProviderRef<Notifier> ref) {
    final notifier = _create(ref);
    if (notifier != null) ref.onDispose(notifier.dispose);

    return notifier;
  }

  @override
  _NotifierProviderElement<Notifier> createElement() {
    return _NotifierProviderElement<Notifier>(this);
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

class _NotifierProviderElement<Notifier extends RestorableProperty<dynamic>?>
    extends ProviderElementBase<Notifier>
    implements RestorableProviderRef<Notifier> {
  _NotifierProviderElement(_NotifierProvider<Notifier> provider)
      : super(provider);

  @override
  Notifier get notifier => requireState;
}

// ignore: subtype_of_sealed_class
/// {@template riverpod.Restorablenotifierprovider.family}
/// A class that allows building a [RestorableProvider] from an external parameter.
/// {@endtemplate}
@sealed
class RestorableProviderFamily<Notifier extends RestorableProperty<dynamic>?,
    Arg> extends Family<Notifier, Arg, RestorableProvider<Notifier>> {
  /// {@macro riverpod.Restorablenotifierprovider.family}
  RestorableProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Notifier, RestorableProviderRef<Notifier>, Arg> _create;

  @override
  RestorableProvider<Notifier> create(Arg argument) {
    return RestorableProvider<Notifier>(
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

  /// {@template riverpod.overridewithprovider}
  /// Overrides a provider with a value, ejecting the default behaviour.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified `dependencies`, it will have no effect.
  ///
  /// The override must not specify a `dependencies`.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       myService.overrideWithProvider(
  ///         // Replace the implementation of the provider with a different one
  ///         Provider((ref) {
  ///           ref.watch('other');
  ///           return MyFakeService(),
  ///         }),
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  Override overrideWithProvider(
    RestorableProvider<Notifier> Function(Arg argument) override,
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
