// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Todo _$TodoFromJson(Map<String, dynamic> json) => _Todo(
      id: json['id'] as String,
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

@ProviderFor(AsyncTodos)
const asyncTodosProvider = AsyncTodosProvider._();

final class AsyncTodosProvider
    extends $AsyncNotifierProvider<AsyncTodos, List<Todo>> {
  const AsyncTodosProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'asyncTodosProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$asyncTodosHash();

  @$internal
  @override
  AsyncTodos create() => AsyncTodos();

  @$internal
  @override
  $AsyncNotifierProviderElement<AsyncTodos, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$asyncTodosHash() => r'fd0d7502a1c17b7cedd2350519649dd680fc48cd';

abstract class _$AsyncTodos extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Todo>>>,
        AsyncValue<List<Todo>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
