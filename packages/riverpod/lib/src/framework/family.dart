part of 'framework.dart';

// TODO throw if a family provider is overriden

abstract class Family<P extends ProviderBase, A> {
  Family(this._create);

  final P Function(Family family, A value) _create;
  final _cache = <A, P>{};

  P call(A value) {
    return _cache.putIfAbsent(value, () => _create(this, value));
  }
}

class FamilyOverride implements Override {
  FamilyOverride(this._family, this.createOverride);

  final ProviderBase Function(Object value) createOverride;
  final Family _family;
}
