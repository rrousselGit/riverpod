part of '../framework.dart';

/// A base class for all families
abstract class Family<State, Arg, FamilyProvider extends ProviderBase<State>>
    extends ProviderOrFamily implements FamilyOverride<Arg> {
  /// A base class for all families
  Family({required this.name, required List<ProviderOrFamily>? dependencies})
      : super(dependencies: dependencies);

  /// The family name.
  @protected
  final String? name;

  @override
  Family<Object?, Arg, ProviderBase<Object?>> get overriddenFamily => this;

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

/// Setup how a family is overridden
typedef SetupFamilyOverride<Arg> = void Function(
  Arg argument,
  void Function({
    required ProviderBase origin,
    required ProviderBase override,
  }),
);

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
abstract class FamilyOverride<Arg> implements Override {
  /// The family that was overridden.
  Family<Object?, Arg, ProviderBase<Object?>> get overriddenFamily;

  /// Allows a family to override all the different providers associated with
  /// an argument.
  void setupOverride(Arg argument, SetupOverride setup);
}
