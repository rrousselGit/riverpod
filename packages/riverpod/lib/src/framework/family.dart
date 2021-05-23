part of '../framework.dart';

/// A base class for all families
abstract class Family<State, Arg, FamilyProvider extends ProviderBase<State>> {
  /// A base class for all families
  Family(this.name);

  /// The family name.
  @protected
  final String? name;

  final _cache = <Arg, FamilyProvider>{};

  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more informations.
  FamilyProvider call(Arg argument) {
    return _cache.putIfAbsent(argument, () {
      final provider = create(argument);

      registerProvider(provider, argument);

      return provider;
    });
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

  /// A debug-only list of all the parameters passed to this family.
  List<Arg>? get debugKeys {
    List<Arg>? result;
    assert(() {
      result = _cache.keys.toList(growable: false);
      return true;
    }(), '');
    return result;
  }
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
    return FamilyOverride(this, (arg) => override(arg as Arg));
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
    return FamilyOverride(this, (arg) => override(arg as Arg));
  }
}

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
class FamilyOverride implements Override {
  /// Do not use
  FamilyOverride(this._family, this._createOverride);

  final ProviderBase Function(Object? argument) _createOverride;
  final Family _family;
}
