// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'todo_list_notifier_add_todo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TodoList)
const todoListProvider = TodoListProvider._();

final class TodoListProvider
    extends $AsyncNotifierProvider<TodoList, List<Todo>> {
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
    FutureOr<List<Todo>> Function(
      Ref,
      TodoList,
    ) build,
  ) {
    return TodoListProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<TodoList, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$todoListHash() => r'4008395aaca8f55312f668c0b2a32e7599f82349';

abstract class _$TodoList extends $AsyncNotifier<List<Todo>> {
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
