import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';

class PersistOptions {
  const PersistOptions({
    this.destroyKey,
    this.cacheTime = const PersistCacheTime(Duration(days: 2)),
  });

  final String? destroyKey;
  final PersistCacheTime cacheTime;
}

@immutable
class PersistedData<T> {
  const PersistedData(this.data, {this.destroyKey, this.expireAt});

  final T data;
  final String? destroyKey;
  final DateTime? expireAt;

  @override
  bool operator ==(Object other) {
    return other is PersistedData<T> &&
        other.data == data &&
        other.destroyKey == destroyKey &&
        other.expireAt == expireAt;
  }

  @override
  int get hashCode => Object.hash(data, destroyKey, expireAt);
}

abstract class Persist<KeyT extends Object?, EncodedT extends Object?> {
  factory Persist.inMemory() = _InMemoryPersist<KeyT, EncodedT>;

  FutureOr<PersistedData<EncodedT>?> read(KeyT key);
  FutureOr<void> write(KeyT key, EncodedT value, PersistOptions options);
  FutureOr<void> delete(KeyT key);
}

class _InMemoryPersist<KeyT, EncodedT> implements Persist<KeyT, EncodedT> {
  final Map<KeyT, PersistedData<EncodedT>> state = {};

  DateTime _currentTimestamp() => clock.now().toUtc();

  @override
  FutureOr<PersistedData<EncodedT>?> read(KeyT key) => state[key];

  @override
  FutureOr<void> write(KeyT key, EncodedT value, PersistOptions options) {
    state[key] = PersistedData(
      value,
      expireAt: switch (options.cacheTime) {
        ForeverPersistCacheTime() => null,
        DurationPersistCacheTime(:final duration) =>
          _currentTimestamp().add(duration),
      },
      destroyKey: options.destroyKey,
    );
  }

  @override
  FutureOr<void> delete(KeyT key) => state.remove(key);
}

sealed class PersistCacheTime {
  const factory PersistCacheTime(Duration duration) = DurationPersistCacheTime;

  /// A cache time that will never expire.
  ///
  /// This is useful for data that should never be deleted ; but comes with
  /// one major downside:
  /// You must manually delete the data when it is no longer needed.
  ///
  /// Specifically, this means that if you ever delete the associated provider
  /// from your application ; then you will have to do a database migration
  /// to delete the data associated with this provider.
  /// If not, then your database will forever contain unused data.
  ///
  /// Riverpod does not provide any tooling to help with this migration. It is
  /// the responsibility of whatever Database you are using to handle this
  /// migration.
  // ignore: constant_identifier_names, voluntary for the sake of unsafeness.
  static const PersistCacheTime unsafe_forever = ForeverPersistCacheTime();
}

class ForeverPersistCacheTime implements PersistCacheTime {
  const ForeverPersistCacheTime();
}

class DurationPersistCacheTime implements PersistCacheTime {
  const DurationPersistCacheTime(this.duration);

  final Duration duration;
}
