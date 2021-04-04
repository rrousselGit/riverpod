part of '../framework.dart';

/// A base class for all *Family variants of providers.
abstract class Family<Created, Listened, Param, Ref extends ProviderReference,
    P extends RootProvider<Created, Listened>> {
  /// A base class for all *Family variants of providers.
  Family(this.builder, this.name);

  /// Implementation detail. Do not use.
  @protected
  final Created Function(Ref ref, Param param) builder;

  /// Implementation detail. Do not use.
  @protected
  final String? name;

  final _cache = <Param, P>{};

  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more informations.
  P call(Param value) {
    return _cache.putIfAbsent(value, () {
      final provider =
          create(value, builder, name == null ? null : '$name ($value)');
      assert(
        provider._from == null,
        'The provider created already belongs to a Family',
      );
      return provider
        .._from = this
        .._argument = value;
    });
  }

  /// Creates the provider for a given parameter.
  P create(
    Param value,
    Created Function(Ref ref, Param param) builder,
    String? name,
  );

  /// A debug-only list of all the parameters passed to this family.
  List<Param>? get debugKeys {
    List<Param>? result;
    assert(() {
      result = _cache.keys.toList(growable: false);
      return true;
    }(), '');
    return result;
  }
}

/// Implements [overrideWithProvider] for families.
///
/// This is implemented as an extension so that providers can override the
/// behavior of [overrideWithProvider] with a function that has a different prototype.
extension FamilyX<Created, Listened, Param, Ref extends ProviderReference,
        P extends RootProvider<Created, Listened>>
    on Family<Created, Listened, Param, Ref, P> {
  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    Created Function(Ref ref, Param param) builderOverride,
  ) {
    return FamilyOverride(
      this,
      (param) => create(param as Param, builderOverride, null),
    );
  }
}

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
class FamilyOverride implements Override {
  /// Do not use
  FamilyOverride(this._family, this._createOverride);

  final RootProvider Function(Object? param) _createOverride;
  final Family _family;
}
