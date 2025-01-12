import 'package:meta/meta.dart';

import '../framework.dart';

/// An interface to enable Riverpod to store the state of providers in a database.
///
/// Should not be implemented. Instead use `with`.
@optionalTypeArgs
mixin NotifierEncoder<ValueT, PersistT extends Persist<Object?, ValueT>> {
  /// A key unique to this provider and parameter combination.
  ///
  /// This key is used to store the state of the provider in a database.
  /// In general, it combines:
  /// - the provider name
  /// - the file location
  /// - all provider parameters
  ///
  /// **Note**:
  /// If a provider is generic, the generic parameters should also be included in the key.
  /// But when doing so, make sure to use a stable serialization method,
  /// and avoid conflicts when the same provider is used with different generics.
  ///
  /// The type of the value returned depends on your [Persist] implementation.
  /// Usually, this will be a [String], but could be anything.
  /// For example, a [Persist] could ask for an instance of a custom class instead,
  /// to have more efficient indexing in the database.
  Object? get persistKey;

  /// Decodes the value from the database to the state of the provider.
  ///
  /// {@template persist.encoded_value}
  /// The type of the encoded value depends on your [Persist] implementation.
  /// A JSON-based [Persist] may store a [String] in the DB, while an alternative
  /// implementation rely on a list of bytes or a custom class.
  /// {@endtemplate}
  ValueT decode(Object? value);

  /// Encodes the state of the provider to a value that can be stored in the database.
  ///
  /// {@macro persist.encoded_value}
  Object? encode();

  /// Extracts the [Persist] options from a provider/container in a type-safe way.
  ///
  /// This should returns the provider's option over the container's option.
  /// Throws an error if the provider specifies a [Persist] option but
  /// the option doesn't implement [PersistT].
  ///
  /// Returns `null` is no matching option is found.
  PersistT? optionsFor(
    ProviderContainer container,
    ProviderBase<Object?> provider,
  ) {
    switch ((provider.persistOptions, container.persistOptions)) {
      case (final PersistT options, _):
      case (_, final PersistT options):
        return options;
      case (!= null, _):
        throw StateError(
          'The provider specified a Persist option, '
          'but the option does not implement $PersistT. '
          'Please make sure to use a Persist option that implements $PersistT.',
        );
      case _:
        return null;
    }
  }
}

@internal
class UnimplementedNotifierPersistError extends Error {
  @override
  String toString() {
    return 'When a notifier uses offline persistence, '
        'it must override `persistKey`, `encode` and `decode`.';
  }
}
