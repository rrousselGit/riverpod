part of 'framework.dart';

abstract class Family<P extends ProviderBase, A> {
  Family(this._create);

  final P Function(A value) _create;
  final _cache = <A, P>{};

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

class FamilyOverride implements Override {
  FamilyOverride(this._family, this.createOverride);

  final ProviderBase Function(Object value) createOverride;
  final Family _family;
}
