// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Todo _$$_TodoFromJson(Map<String, dynamic> json) => _$_Todo(
      id: json['id'] as String,
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$$_TodoToJson(_$_Todo instance) => <String, dynamic>{
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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
