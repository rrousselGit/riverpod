import 'dart:convert';

import 'persist.dart';

/// {@template json_persist}
/// An annotation placed on Notifiers to indicated that they should be persisted
/// using JSON.
///
/// For [JsonPersist] to work, all involved objects must either be primitive objects
/// such as [int], [String], [bool], [double], [List], [Map], or objects that
/// contain a `fromJson/toJson` method pair.
///
/// Notifiers should then call [NotifierPersistX.persist] in their `build` method,
/// and pass a compatible [Storage].
///
/// ```dart
/// @riverpod
/// @JsonPersist()
/// class MyNotifier extends _$MyNotifier {
///   @override
///   SomeState build() {
///     persist(
///       // A storage that supports JSON-based persistence.
///       storage: ref.watch(storageProvider),
///     );
///   }
/// }
///
/// class SomeState {
///   const SomeState(this.count);
///
///   SomeState.fromJson(Map<String, Object?> json)
///    : count = json['count'] as int;
///
///   final int count;
///
///   Map<String, Object?> toJson() => { 'count': count };
/// }
/// ```
/// {@endtemplate}
class JsonPersist implements RiverpodPersist {
  /// {@macro json_persist}
  const JsonPersist();
}

/// Implementation detail of [JsonPersist]. Do not use.
const $jsonCodex = json;
