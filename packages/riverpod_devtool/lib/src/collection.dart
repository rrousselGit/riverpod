import 'package:meta/meta.dart';

class SetBuilder<ItemT> {
  SetBuilder(this._set);
  Set<ItemT> _set;

  bool _changed = false;

  bool add(ItemT value) {
    if (!_changed) {
      _set = Set<ItemT>.from(_set);
      _changed = true;
    }

    return _set.add(value);
  }

  Set<ItemT> build() => _set;
}

class MapBuilder<KeyT, ValueT> {
  MapBuilder(this._map);
  Map<KeyT, ValueT> _map;

  bool _changed = false;

  void operator []=(KeyT key, ValueT value) {
    if (!_changed) {
      _map = Map<KeyT, ValueT>.from(_map);
      _changed = true;
    }

    _map[key] = value;
  }

  ValueT? remove(KeyT key) {
    if (!_changed) {
      _map = Map<KeyT, ValueT>.from(_map);
      _changed = true;
    }

    return _map.remove(key);
  }

  Map<KeyT, ValueT> build() => _map;
}

/// An unmodifiable view of a [Map].
extension type UnmodifiableMap<KeyT, ValueT>(Map<KeyT, ValueT> _map)
    implements Map<KeyT, ValueT> {
  /// This operation is not supported by an unmodifiable map.
  @Deprecated('Will throw')
  @redeclare
  void operator []=(KeyT key, ValueT value) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never addAll(Map<KeyT, ValueT> other) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never addEntries(Iterable<MapEntry<KeyT, ValueT>> entries) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never clear() {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never remove(Object? key) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never removeWhere(bool Function(KeyT key, ValueT value) test) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never putIfAbsent(KeyT key, ValueT Function() ifAbsent) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never update(
    KeyT key,
    ValueT Function(ValueT value) update, {
    ValueT Function()? ifAbsent,
  }) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }

  /// This operation is not supported by an unmodifiable map.
  @redeclare
  Never updateAll(ValueT Function(KeyT key, ValueT value) update) {
    throw UnsupportedError('Cannot modify unmodifiable map');
  }
}
