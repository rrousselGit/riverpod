part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class ChangeNotifierProviderRef<Notifier extends ChangeNotifier?>
    implements Ref {
  /// The [ChangeNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  Notifier get notifier;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider}
@sealed
class ChangeNotifierProvider<Notifier extends ChangeNotifier?>
    extends AlwaysAliveProviderBase<Notifier>
    with
        ChangeNotifierProviderOverrideMixin<Notifier>,
        OverrideWithProviderMixin<Notifier, ChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider}
  ChangeNotifierProvider(
    Create<Notifier, ChangeNotifierProviderRef<Notifier>> create, {
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
  static const family = ChangeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeChangeNotifierProviderBuilder();

  @override
  ProviderBase<Notifier> get originProvider => notifier;

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
class _NotifierProvider<Notifier extends ChangeNotifier?>
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

  final Create<Notifier, ChangeNotifierProviderRef<Notifier>> _create;

  @override
  Notifier create(covariant ChangeNotifierProviderRef<Notifier> ref) {
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

class _NotifierProviderElement<Notifier extends ChangeNotifier?>
    extends ProviderElementBase<Notifier>
    implements ChangeNotifierProviderRef<Notifier> {
  _NotifierProviderElement(_NotifierProvider<Notifier> provider)
      : super(provider);

  @override
  Notifier get notifier => requireState;
}

// ignore: subtype_of_sealed_class
/// {@template riverpod.changenotifierprovider.family}
/// A class that allows building a [ChangeNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class ChangeNotifierProviderFamily<Notifier extends ChangeNotifier?, Arg>
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
    return ChangeNotifierProvider<Notifier>(
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
}
