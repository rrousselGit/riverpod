export 'package:riverpod/src/internals.dart'
    show
        StorageOptions,
        PersistedData,
        Storage,
        StorageCacheTime,
        NotifierPersistX,
        PersistResult;

/// {@template riverpod_persist_annotation}
/// An interface to mark annotations as "used to enable persistence for a provider".
///
/// This tells Riverpod that a separate code-generator wants to modify Notifiers
/// to add persistence capabilities.
///
/// **Note**: When this annotation is used, Riverpod will no-longer
/// generate a `_$MyNotifier`. Instead it will generate a `_$MyNotifierBase`
/// and then expect the third-party generator to generate a `_$MyNotifier`
/// that extends `_$MyNotifierBase`.
/// {@endtemplate}
class RiverpodPersist {
  /// {@macro riverpod_persist_annotation}
  const RiverpodPersist();
}
