import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';

import '../../riverpod.dart';

class StorageOptions {
  const StorageOptions({
    this.destroyKey,
    this.cacheTime = const StorageCacheTime(Duration(days: 2)),
  });

  final String? destroyKey;
  final StorageCacheTime cacheTime;
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

/// An interface to enable Riverpod to interact with a database.
///
/// This is used in conjunction with [Persistable] to enable persistence for a
/// notifier.
///
/// Storages are generally implemented by third-party packages.
/// Riverpod provides an official implementation of [Storage] that stores data
/// using SQLite, in the `riverpod_sqflite` package.
abstract class Storage<KeyT extends Object?, EncodedT extends Object?> {
  /// A storage that stores data in-memory.
  ///
  /// This is a useful API for testing. Inside unit tests, you can override
  /// your [Storage] provider to use this implementation.
  ///
  /// This implementation is not suitable for production use-cases, as it will
  /// not persist data across app restarts.
  @visibleForTesting
  factory Storage.inMemory() = _InMemoryPersist<KeyT, EncodedT>;

  /// Reads the data associated with [key].
  ///
  /// If no data is associated with [key], this method should return `null`.
  /// Otherwise it should return the data associated with [key].
  ///
  /// It is fine to return expired data, as [Persistable] will handle the
  /// expiration logic.
  ///
  /// If possible, make this method synchronous. This can enable
  /// [Persistable] to be synchronous too ; which will allow the persisted
  /// data to be available as soon as possible in the UI.
  FutureOr<PersistedData<EncodedT>?> read(KeyT key);

  /// Writes [value] associated with [key].
  ///
  /// This should create a new entry if [key] does not exist, or update the
  /// existing entry if it does.
  FutureOr<void> write(KeyT key, EncodedT value, StorageOptions options);

  /// Deletes the data associated with [key].
  ///
  /// If [key] does not exist, this method should do nothing.
  /// This method will usually be called by [Persistable] when either
  /// [StorageOptions.destroyKey] changes or [StorageOptions.cacheTime] expires.
  FutureOr<void> delete(KeyT key);
}

class _InMemoryPersist<KeyT, EncodedT> implements Storage<KeyT, EncodedT> {
  final Map<KeyT, PersistedData<EncodedT>> state = {};

  DateTime _currentTimestamp() => clock.now().toUtc();

  @override
  FutureOr<PersistedData<EncodedT>?> read(KeyT key) => state[key];

  @override
  FutureOr<void> write(KeyT key, EncodedT value, StorageOptions options) {
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

sealed class StorageCacheTime {
  const factory StorageCacheTime(Duration duration) = DurationPersistCacheTime;

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
  static const StorageCacheTime unsafe_forever = ForeverPersistCacheTime();
}

class ForeverPersistCacheTime implements StorageCacheTime {
  const ForeverPersistCacheTime();
}

class DurationPersistCacheTime implements StorageCacheTime {
  const DurationPersistCacheTime(this.duration);

  final Duration duration;
}
