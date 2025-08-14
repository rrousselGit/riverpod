// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoList)
const todoListProvider = TodoListProvider._();

final class TodoListProvider extends $NotifierProvider<TodoList, List<Todo>> {
  const TodoListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  TodoList create() => TodoList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Todo>>(value),
    );
  }
}

String _$todoListHash() => r'6c965beb867ffeee119133f0ae2e6ebeb68e6f7e';

abstract class _$TodoList extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Todo>, List<Todo>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Todo>, List<Todo>>, List<Todo>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
