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

@ProviderFor(storage)
const storageProvider = StorageProvider._();

final class StorageProvider extends $FunctionalProvider<
        AsyncValue<JsonSqFliteStorage>, FutureOr<JsonSqFliteStorage>>
    with
        $FutureModifier<JsonSqFliteStorage>,
        $FutureProvider<JsonSqFliteStorage> {
  const StorageProvider._(
      {FutureOr<JsonSqFliteStorage> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'storageProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<JsonSqFliteStorage> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<JsonSqFliteStorage> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  StorageProvider $copyWithCreate(
    FutureOr<JsonSqFliteStorage> Function(
      Ref ref,
    ) create,
  ) {
    return StorageProvider._(create: create);
  }

  @override
  FutureOr<JsonSqFliteStorage> create(Ref ref) {
    final _$cb = _createCb ?? storage;
    return _$cb(ref);
  }
}

String _$storageHash() => r'f0dc33f3f7b62aa7f1ecd8faff381278503b1b01';

@ProviderFor(TodosNotifier)
@JsonPersist()
const todosNotifierProvider = TodosNotifierProvider._();

final class TodosNotifierProvider
    extends $AsyncNotifierProvider<TodosNotifier, List<Todo>> {
  const TodosNotifierProvider._(
      {super.runNotifierBuildOverride, TodosNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'todosNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final TodosNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$todosNotifierHash();

  @$internal
  @override
  TodosNotifier create() => _createCb?.call() ?? TodosNotifier();

  @$internal
  @override
  TodosNotifierProvider $copyWithCreate(
    TodosNotifier Function() create,
  ) {
    return TodosNotifierProvider._(create: create);
  }

  @$internal
  @override
  TodosNotifierProvider $copyWithBuild(
    FutureOr<List<Todo>> Function(
      Ref,
      TodosNotifier,
    ) build,
  ) {
    return TodosNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<TodosNotifier, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$todosNotifierHash() => r'f7c580875a00ab559ff61cbd0f6986fe1fd515e6';

abstract class _$TodosNotifierBase extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<List<Todo>>>,
        AsyncValue<List<Todo>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// JsonGenerator
// **************************************************************************

abstract class _$TodosNotifier extends _$TodosNotifierBase
    with Persistable<List<Todo>, String, String> {
  @override
  FutureOr<void> persist({
    String? key,
    required FutureOr<Storage<String, String>> storage,
    String Function(List<Todo> state)? encode,
    List<Todo> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    final resolvedKey = "TodosNotifier";

    return super.persist(
      key: resolvedKey,
      storage: storage,
      encode: encode ?? (value) => $jsonCodex.encode(state.requireValue),
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
