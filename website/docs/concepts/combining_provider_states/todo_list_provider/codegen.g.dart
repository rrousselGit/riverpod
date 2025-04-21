// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  TodoList create() => TodoList();

  @$internal
  @override
  $NotifierProviderElement<TodoList, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>>(value),
    );
  }
}

String _$todoListHash() => r'6c965beb867ffeee119133f0ae2e6ebeb68e6f7e';

abstract class _$TodoList extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Todo>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<List<Todo>>, List<Todo>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
