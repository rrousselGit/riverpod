import 'package:meta/meta.dart';

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
