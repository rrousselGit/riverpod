part of '../framework.dart';

/// A base class for all *Family variants of providers.
abstract class Family<Created, Listened, Param, Ref extends ProviderReference,
    P extends ProviderBase<Created, Listened>> {
  Family(this._builder, this.name);

  final Created Function(Ref ref, Param param) _builder;
  // TODO make private and pass the contatenario with `param` to [create]
  final String name;

  final _cache = <Param, P>{};

  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferrably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more informations.
  P call(Param value) {
    return _cache.putIfAbsent(value, () {
      final provider = create(value, _builder);
      assert(
        provider._from == null,
        'The provider created already belongs to a Family',
      );
      return provider
        .._from = this
        .._argument = value;
    });
  }

  P create(Param value, Created Function(Ref ref, Param param) builder);

  List<Param> get debugKeys {
    List<Param> result;
    assert(() {
      result = _cache.keys.toList(growable: false);
      return true;
    }(), '');
    return result;
  }
}

extension FamilyX<Created, Listened, Param, Ref extends ProviderReference,
        P extends ProviderBase<Created, Listened>>
    on Family<Created, Listened, Param, Ref, P> {
  /// Overrides the behavior of a family for a part of the application.
  Override overrideWithProvider(
    Created Function(Ref ref, Param param) builderOverride,
  ) {
    return FamilyOverride(
      this,
      (dynamic param) {
        return create(param as Param, builderOverride);
      },
    );
  }
}

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
class FamilyOverride implements Override {
  /// Do not use
  FamilyOverride(this._family, this._createOverride);

  final ProviderBase Function(dynamic param) _createOverride;
  final Family _family;
}
