// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TodoList)
const todoListProvider = TodoListProvider._();

final class TodoListProvider extends $NotifierProvider<TodoList, List<Todo>> {
  const TodoListProvider._(
      {super.runNotifierBuildOverride, TodoList Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoListProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final TodoList Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>>(value),
    );
  }

  @$internal
  @override
  TodoList create() => _createCb?.call() ?? TodoList();

  @$internal
  @override
  TodoListProvider $copyWithCreate(
    TodoList Function() create,
  ) {
    return TodoListProvider._(create: create);
  }

  @$internal
  @override
  TodoListProvider $copyWithBuild(
    List<Todo> Function(
      Ref<List<Todo>>,
      TodoList,
    ) build,
  ) {
    return TodoListProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<TodoList, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$todoListHash() => r'6c965beb867ffeee119133f0ae2e6ebeb68e6f7e';

abstract class _$TodoList extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$internal
  @override
  List<Todo> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
