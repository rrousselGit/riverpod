// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Todo _$TodoFromJson(Map<String, dynamic> json) => _Todo(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$TodoToJson(_Todo instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'completed': instance.completed,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(storage)
const storageProvider = StorageProvider._();

final class StorageProvider extends $FunctionalProvider<
        AsyncValue<JsonSqFliteStorage>,
        JsonSqFliteStorage,
        FutureOr<JsonSqFliteStorage>>
    with
        $FutureModifier<JsonSqFliteStorage>,
        $FutureProvider<JsonSqFliteStorage> {
  const StorageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<JsonSqFliteStorage> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<JsonSqFliteStorage> create(Ref ref) {
    return storage(ref);
  }
}

String _$storageHash() => r'f0dc33f3f7b62aa7f1ecd8faff381278503b1b01';

@ProviderFor(TodosNotifier)
@JsonPersist()
const todosNotifierProvider = TodosNotifierProvider._();

final class TodosNotifierProvider
    extends $AsyncNotifierProvider<TodosNotifier, List<Todo>> {
  const TodosNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todosNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todosNotifierHash();

  @$internal
  @override
  TodosNotifier create() => TodosNotifier();
}

String _$todosNotifierHash() => r'82bca33ebc86b96dd0d7cd2942c043114f05b055';

abstract class _$TodosNotifierBase extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>, List<Todo>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Todo>>, List<Todo>>,
        AsyncValue<List<Todo>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// **************************************************************************
// JsonGenerator
// **************************************************************************

abstract class _$TodosNotifier extends _$TodosNotifierBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "TodosNotifier";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  PersistResult persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(List<Todo> state)? encode,
    List<Todo> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode: decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as List)
                .map((e) => Todo.fromJson(e as Map<String, Object?>))
                .toList();
          },
      options: options,
    );
  }
}
