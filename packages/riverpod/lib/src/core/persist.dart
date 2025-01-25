import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';

import '../framework.dart';

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
  const PersistedData({required this.data, this.destroyKey, this.expireAt});

  final T data;
  final String? destroyKey;
  final DateTime? expireAt;
}

abstract class Persist<KeyT, EncodedT extends Object?> {
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
      data: value,
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

/// A mixin to enable offline-persistence for a given [NotifierBase].
///
/// The generic parameters correspond to:
/// 1. The type of the state, after unwrapping any [AsyncValue].
///    It is generally the same type as the one passed to your notifier.
/// 2. The type of the value that will be stored in the database.
///    If you use JSON encoding, this is generally a [String].
///    If you use a custom encoding, this could be a custom class or a list of bytes.
///
/// Using this mixin in a notifier will automatically mark this notifier as
/// needing to be persisted offline.
///
/// Should not be implemented. Instead use `with`.
@optionalTypeArgs
mixin NotifierEncoder<KeyT, DecodedT, EncodedT> on $Value<DecodedT> {
  /// A key unique to this provider and parameter combination.
  ///
  /// This key is used to store the state of the provider in a database.
  /// In general, it combines:
  /// - the provider name
  /// - all provider parameters
  ///
  /// When modifying the source code of a provider, be careful when changing its
  /// key.
  /// A different key means that devices using a previous version of your app
  /// will lose their state when updating to the new version.
  ///
  /// **Note**:
  /// This key should not change for a given provider/parameter combination.
  /// As such, do not include any random values in the key or values such as the current date.
  ///
  /// **Note**:
  /// This key must be unique across all providers.
  /// It is an error if:
  /// - two providers have the same key
  /// - the same provider with different parameters have the same key
  ///
  /// As such if a provider is generic, the generic parameters should also be
  /// included in the key. But when doing so, make sure to use a stable serialization method,
  /// and avoid conflicts when the same provider is used with different generics.
  ///
  /// The type of the value returned depends on your [Persist] implementation.
  /// Usually, this will be a [String], but could be anything.
  /// For example, a [Persist] could ask for an instance of a custom class instead,
  /// to have more efficient indexing in the database.
  Object get persistKey;

  PersistOptions get persistOptions => const PersistOptions();

  /// Decodes the value from the database to the state of the provider.
  ///
  /// {@template persist.encoded_value}
  /// The type of the encoded value depends on your [Persist] implementation.
  /// A JSON-based [Persist] may store a [String] in the DB, while an alternative
  /// implementation rely on a list of bytes or a custom class.
  /// {@endtemplate}
  DecodedT decode(EncodedT value);

  /// Encodes the state of the provider to a value that can be stored in the database.
  ///
  /// {@macro persist.encoded_value}
  EncodedT encode();

  /// Returns the [Persist] object used to interact with the database.
  ///
  /// By default, this returns [ProviderContainer.persist] and will throw
  /// if [ProviderContainer.persist] is incompatible with how this provider
  /// is encoded.
  ///
  /// Notifiers can override this method to provide a custom [Persist] object.
  Persist<KeyT, EncodedT> get persist {
    return switch ((this as NotifierBase).ref.container.persist) {
      final Persist<KeyT, EncodedT> persist? => persist,
      Persist() => throw StateError('''
The notifier `$this` is expected to be encoded into a value of type `$EncodedT`,
but the default Persist option is not compatible with this type.

To fix, either:
- Change your ProviderContainer.persist to be compatible with persisting `$EncodedT`.
- Override the `persist` getter in your notifier to return a Persist instance.
'''),
      null => throw StateError('''
The notifier `$this` opted-in to offline persistence, but no Persist option was provided on ProviderContainer.

To fix, either:
- Provide a ProviderContainer.persist value.
- Override the `persist` getter in your notifier to return a Persist instance.
'''),
    };
  }
}
