part of '../framework.dart';

/// A [Create] equivalent used by [Family].
typedef FamilyCreate<T, R extends Ref, Arg> = T Function(
  R ref,
  Arg arg,
);

/// A base class for all families
abstract class Family<State, Arg, FamilyProvider extends ProviderBase<State>>
    extends ProviderOrFamily implements FamilyOverride<Arg> {
  /// A base class for all families
  Family({
    required this.name,
    required this.dependencies,
    required this.cacheTime,
    required this.disposeDelay,
  });

  /// {@macro riverpod.cache_time}
  final Duration? cacheTime;

  /// {@macro riverpod.dispose_delay}
  final Duration? disposeDelay;

  @override
  final List<ProviderOrFamily>? dependencies;

  /// The family name.
  @protected
  final String? name;

  @override
  Family<dynamic, dynamic, ProviderBase>? get from => null;

  @override
  Family<Object?, Arg, ProviderBase<Object?>> get overriddenFamily => this;

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    setup(origin: call(argument), override: call(argument));
  }

  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more information.
  FamilyProvider call(Arg argument);
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
  /// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
  /// to override the behavior of a "family" for part of the application.
  // coverage:ignore-start
  factory FamilyOverride(
    Family<Object?, Arg, ProviderBase<Object?>> overriddenFamily,
    void Function(Arg argument, SetupOverride setup) setup,
  ) = _FamilyOverride<Arg>;
  // coverage:ignore-end

  /// The family that was overridden.
  Family<Object?, Arg, ProviderBase<Object?>> get overriddenFamily;

  /// Allows a family to override all the different providers associated with
  /// an argument.
  void setupOverride(Arg argument, SetupOverride setup);
}

class _FamilyOverride<Arg> implements FamilyOverride<Arg> {
  _FamilyOverride(this.overriddenFamily, this._setup);

  @override
  final Family<Object?, Arg, ProviderBase<Object?>> overriddenFamily;

  final void Function(Arg argument, SetupOverride setup) _setup;

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    _setup(argument, setup);
  }
}

// /// An extension that adds [overrideWithProvider] to [Family].
// extension XFamily<State, Arg,
//         FamilyProvider extends AlwaysAliveProviderBase<State>>
//     on Family<State, Arg, FamilyProvider> {
//   /// Overrides the behavior of a family for a part of the application.
//   ///
//   /// {@macro riverpod.overrideWith}
//   Override overrideWithProvider(
//     AlwaysAliveProviderBase<State> Function(Arg argument) override,
//   ) {
//     return _FamilyOverride<Arg>(this, (arg, setup) {
//       setup(origin: call(arg), override: override(arg));
//     });
//   }
// }

// /// An extension that adds [overrideWithProvider] to [Family].
// extension XAutoDisposeFamily<State, Arg,
//         FamilyProvider extends AutoDisposeProviderBase<State>>
//     on Family<State, Arg, FamilyProvider> {
//   /// Overrides the behavior of a family for a part of the application.
//   ///
//   /// {@macro riverpod.overrideWith}
//   Override overrideWithProvider(
//     AutoDisposeProviderBase<State> Function(Arg argument) override,
//   ) {
//     return _FamilyOverride<Arg>(this, (arg, setup) {
//       setup(origin: call(arg), override: override(arg));
//     });
//   }
// }
