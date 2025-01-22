import 'package:meta/meta.dart';

import '../framework.dart';

/// An interface to enable Riverpod to store the state of providers in a database.
///
/// Should not be implemented. Instead use `with`.
@optionalTypeArgs
mixin NotifierEncoder<DecodedT, EncodedT> on $Value<DecodedT> {
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

  /// Decodes the value from the database to the state of the provider.
  ///
  /// {@template persist.encoded_value}
  /// The type of the encoded value depends on your [Persist] implementation.
  /// A JSON-based [Persist] may store a [String] in the DB, while an alternative
  /// implementation rely on a list of bytes or a custom class.
  /// {@endtemplate}
  DecodedT decode(Object? value);

  /// Encodes the state of the provider to a value that can be stored in the database.
  ///
  /// {@macro persist.encoded_value}
  Object? encode();

  /// Returns the [Persist] object used to interact with the database.
  ///
  /// By default, this returns [ProviderContainer.persist] and will throw
  /// if [ProviderContainer.persist] is incompatible with how this provider
  /// is encoded.
  ///
  /// Notifiers can override this method to provide a custom [Persist] object.
  Persist<EncodedT> get persist {
    return switch ((this as NotifierBase).ref.container.persist) {
      final Persist<EncodedT> persist? => persist,
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
