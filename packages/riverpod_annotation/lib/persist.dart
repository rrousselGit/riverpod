/// {@template riverpod_persist_annotation}
/// An interface to mark annotations as "used to enable persistence for a provider".
///
/// This avoids having to write:
///
/// ```dart
/// @Riverpod(persist: true)
/// @MyCustomAnnotation()
/// ```
/// when you can write:
/// ```dart
/// @riverpod
/// @MyCustomAnnotation()
/// ```
///
/// **Note**: When this annotation is used, Riverpod will expect that a
/// mixin of the name `_${providerName}Persist` is available in the same file.
/// That mixin will be expected to implement the `PersistAdapter` interface.
///
/// It is the role of this annotation to generate the mixin mentioned mixin.
/// {@endtemplate}
class RiverpodPersistAnnotation {
  /// {@macro riverpod_persist_annotation}
  const RiverpodPersistAnnotation();
}
