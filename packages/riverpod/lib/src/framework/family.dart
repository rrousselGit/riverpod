part of 'framework.dart';

/// A base class for all *Family variants of providers.
abstract class Family<P extends ProviderBase, A> {
  /// Creates the provider from an external value.
  Family(this._create);

  final P Function(A value) _create;
  final _cache = <A, P>{};

  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferrably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more informations.
  P call(A value) {
    return _cache.putIfAbsent(value, () {
      final provider = _create(value);
      assert(
        provider._family == null,
        'The provider created already belongs to a Family',
      );
      return provider
        .._family = this
        .._parameter = value;
    });
  }
}

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
class FamilyOverride implements Override {
  /// Do not use
  FamilyOverride(this._family, this._createOverride);

  final ProviderBase Function(Object value) _createOverride;
  final Family _family;
}
