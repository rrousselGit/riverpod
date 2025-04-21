// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'todo_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(todoList)
const todoListProvider = TodoListProvider._();

final class TodoListProvider
    extends $FunctionalProvider<AsyncValue<List<Todo>>, FutureOr<List<Todo>>>
    with $FutureModifier<List<Todo>>, $FutureProvider<List<Todo>> {
  const TodoListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoListProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  $FutureProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Todo>> create(Ref ref) {
    return todoList(ref);
  }
}

String _$todoListHash() => r'79ea254a2b6239c9fbcc2b5e6f075a3e5b72598e';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
