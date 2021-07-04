part of '../framework.dart';

/// A base class for all families
abstract class Family<State, Arg, FamilyProvider extends ProviderBase<State>>
    implements FamilyOverride<Arg> {
  /// A base class for all families
  Family(this.name);

  /// The family name.
  @protected
  final String? name;

  @override
  Family<Object?, Arg, ProviderBase<Object?>> get overridenFamily => this;

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    setup(origin: call(argument), override: call(argument));
  }

  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more informations.
  FamilyProvider call(Arg argument) {
    final provider = create(argument);

    registerProvider(provider, argument);

    return provider;
  }

  /// Register a provider as part of this family.
  @protected
  void registerProvider(ProviderBase provider, Arg argument) {
    assert(
      provider._from == null,
      'The provider created already belongs to a Family',
    );

    provider
      .._from = this
      .._argument = argument;
  }

  /// Creates the provider for a given parameter.
  @protected
  FamilyProvider create(Arg argument);
}

/// An extension that adds [overrideWithProvider] to [Family].
extension XFamily<State, Arg,
        FamilyProvider extends AlwaysAliveProviderBase<State>>
    on Family<State, Arg, FamilyProvider> {
  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AlwaysAliveProviderBase<State> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      setup(origin: call(arg), override: override(arg));
    });
  }
}

/// An extension that adds [overrideWithProvider] to [Family].
extension XAutoDisposeFamily<State, Arg,
        FamilyProvider extends AutoDisposeProviderBase<State>>
    on Family<State, Arg, FamilyProvider> {
  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeProviderBase<State> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      setup(origin: call(arg), override: override(arg));
    });
  }
}

// ignore: avoid_private_typedef_functions
typedef _SetupFamilyOverride<Arg> = void Function(
  Arg argument,
  void Function({
    required ProviderBase origin,
    required ProviderBase override,
  }),
);

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
abstract class FamilyOverride<Arg> implements Override {
  /// Do not use
  factory FamilyOverride(
    Family<Object?, Arg, ProviderBase<Object?>> family,
    _SetupFamilyOverride<Arg> createOverride,
  ) = _FamilyOverride;

  /// The family that was overriden.
  Family<Object?, Arg, ProviderBase<Object?>> get overridenFamily;

  /// Allows a family to override all the different providers associated with
  /// an argument.
  void setupOverride(Arg argument, SetupOverride setup);
}

class _FamilyOverride<Arg> implements FamilyOverride<Arg> {
  _FamilyOverride(this.overridenFamily, this._createOverride);

  @override
  final Family<Object?, Arg, ProviderBase<Object?>> overridenFamily;
  final _SetupFamilyOverride<Arg> _createOverride;

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    _createOverride(argument, setup);
  }
}
