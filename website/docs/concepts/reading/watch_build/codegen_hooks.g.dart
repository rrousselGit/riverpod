// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen_hooks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef CounterRef = Ref<int>;

@ProviderFor(counter)
const counterProvider = CounterProvider._();

final class CounterProvider extends $FunctionalProvider<int, int, CounterRef>
    with $Provider<int, CounterRef> {
  const CounterProvider._(
      {int Function(
        CounterRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'counterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CounterRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  CounterProvider $copyWithCreate(
    int Function(
      CounterRef ref,
    ) create,
  ) {
    return CounterProvider._(create: create);
  }

  @override
  int create(CounterRef ref) {
    final _$cb = _createCb ?? counter;
    return _$cb(ref);
  }
}

String _$counterHash() => r'9b0db44ecc47057e79891e5ecd92d34b08637679';

@ProviderFor(TodoList)
const todoListProvider = TodoListProvider._();

final class TodoListProvider extends $NotifierProvider<TodoList, List<Todo>> {
  const TodoListProvider._(
      {super.runNotifierBuildOverride, TodoList Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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
  $NotifierProviderElement<TodoList, List<Todo>> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$todoListHash() => r'77f007cd4f5105330a4c2ab8555ea0d1716945c1';

abstract class _$TodoList extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$internal
  @override
  List<Todo> runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
