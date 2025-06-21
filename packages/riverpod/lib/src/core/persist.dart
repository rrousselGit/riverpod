@publicInPersist
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';

import '../common/internal_lints.dart';
import '../framework.dart';

/// {@template storage_options}
/// Options to enable a [Storage] to persist state.
///
/// Those are passed to [NotifierPersistX.persist].
/// {@endtemplate}
final class StorageOptions {
  /// {@macro storage_options}
  const StorageOptions({
    this.destroyKey,
    this.cacheTime = const StorageCacheTime(Duration(days: 2)),
  });

  /// A key to forcibly destroy the associated state.
  ///
  /// The use-case for this option is to simplify database migration
  /// when a provider changes its state in a breaking way.
  ///
  /// Instead of a complex database migration, an alternative is to change
  /// the [destroyKey] of the provider before deploying the application.
  /// When doing so, the old state will be destroyed, and a new fresh
  /// state will be created.
  ///
  /// This key should be stable across application restarts.
  /// It is highly recommended to use a constant value for this key.
  final String? destroyKey;

  /// The time before the data expires.
  ///
  /// State that expired will be deleted from the database upon:
  /// - application restart
  /// - reading the provider after the expiration time
  final StorageCacheTime cacheTime;
}

/// A state representation of how the data is persisted.
///
/// This includes the data itself, along with various metadata that should
/// also be persisted.
@immutable
final class PersistedData<DataT> {
  /// A state representation of how the data is persisted.
  ///
  /// This includes the data itself, along with various metadata that should
  /// also be persisted.
  const PersistedData(this.data, {this.destroyKey, this.expireAt});

  /// The persisted data.
  final DataT data;

  /// The key passed to [StorageOptions.destroyKey].
  final String? destroyKey;

  /// The date at which the data expires.
  ///
  /// This is based off the [StorageOptions.cacheTime].
  final DateTime? expireAt;

  @override
  bool operator ==(Object other) {
    return other is PersistedData<DataT> &&
        other.data == data &&
        other.destroyKey == destroyKey &&
        other.expireAt == expireAt;
  }

  @override
  int get hashCode => Object.hash(data, destroyKey, expireAt);
}

/// An interface to enable Riverpod to interact with a database.
///
/// This is used in conjunction with [NotifierPersistX.persist] to enable persistence
/// for a notifier.
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
  /// It is fine to return expired data, as [NotifierPersistX.persist] will handle the
  /// expiration logic.
  ///
  /// If possible, make this method synchronous. This can enable
  /// [NotifierPersistX.persist] to be synchronous too ; which will allow the persisted
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
  /// This method will usually be called by [NotifierPersistX.persist] when either
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
        StorageCacheTime(duration: null) => null,
        StorageCacheTime(:final duration?) => _currentTimestamp().add(duration),
      },
      destroyKey: options.destroyKey,
    );
  }

  @override
  FutureOr<void> delete(KeyT key) => state.remove(key);
}

/// {@template storage_cache_time}
/// A cache time that will be used to determine when the data should be
/// deleted.
///
/// It is discouraged to "forever persist" state, as this can lead to
/// a form of memory leak.
/// If a provider was to be persisted forever then deleted from the application's
/// source code, the data would still be present in the database of existing
/// users.
///
/// If you want to forever persist state, you will have to manually deal with
/// database migration to gracefully handle those edge-cases.
/// {@endtemplate}
final class StorageCacheTime {
  /// {@macro storage_cache_time}
  const StorageCacheTime(Duration this.duration);
  const StorageCacheTime._(this.duration);

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
  static const StorageCacheTime unsafe_forever = StorageCacheTime._(null);

  /// The time before the data expires.
  ///
  /// If null, the data will never expire.
  final Duration? duration;
}
