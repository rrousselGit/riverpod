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

  ValueT? operator [](KeyT key) => _map[key];

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
