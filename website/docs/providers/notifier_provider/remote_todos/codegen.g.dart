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

String _$asyncTodosHash() => r'fd0d7502a1c17b7cedd2350519649dd680fc48cd';

/// See also [AsyncTodos].
@ProviderFor(AsyncTodos)
final asyncTodosProvider =
    AutoDisposeAsyncNotifierProvider<AsyncTodos, List<Todo>>.internal(
  AsyncTodos.new,
  name: r'asyncTodosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$asyncTodosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsyncTodos = AutoDisposeAsyncNotifier<List<Todo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
