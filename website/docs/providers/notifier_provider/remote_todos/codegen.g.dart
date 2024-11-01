// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
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
  const AsyncTodosProvider._(
      {super.runNotifierBuildOverride, AsyncTodos Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'asyncTodosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AsyncTodos Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$asyncTodosHash();

  @$internal
  @override
  AsyncTodos create() => _createCb?.call() ?? AsyncTodos();

  @$internal
  @override
  AsyncTodosProvider $copyWithCreate(
    AsyncTodos Function() create,
  ) {
    return AsyncTodosProvider._(create: create);
  }

  @$internal
  @override
  AsyncTodosProvider $copyWithBuild(
    FutureOr<List<Todo>> Function(
      Ref<AsyncValue<List<Todo>>>,
      AsyncTodos,
    ) build,
  ) {
    return AsyncTodosProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<AsyncTodos, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$asyncTodosHash() => r'fd0d7502a1c17b7cedd2350519649dd680fc48cd';

abstract class _$AsyncTodos extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$internal
  @override
  FutureOr<List<Todo>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
