// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'combine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef TodosRef = Ref<List<Todo>>;

@ProviderFor(todos)
const todosProvider = TodosProvider._();

final class TodosProvider extends $FunctionalProvider<List<Todo>, List<Todo>>
    with $Provider<List<Todo>, TodosRef> {
  const TodosProvider._(
      {List<Todo> Function(
        TodosRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'todosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    TodosRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$todosHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<List<Todo>> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  TodosProvider $copyWithCreate(
    List<Todo> Function(
      TodosRef ref,
    ) create,
  ) {
    return TodosProvider._(create: create);
  }

  @override
  List<Todo> create(TodosRef ref) {
    final _$cb = _createCb ?? todos;
    return _$cb(ref);
  }
}

String _$todosHash() => r'146df519c4c2f843a867e4c6f5983259194f34fc';

typedef FilterRef = Ref<Filter>;

@ProviderFor(filter)
const filterProvider = FilterProvider._();

final class FilterProvider extends $FunctionalProvider<Filter, Filter>
    with $Provider<Filter, FilterRef> {
  const FilterProvider._(
      {Filter Function(
        FilterRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'filterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Filter Function(
    FilterRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$filterHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Filter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Filter>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Filter> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  FilterProvider $copyWithCreate(
    Filter Function(
      FilterRef ref,
    ) create,
  ) {
    return FilterProvider._(create: create);
  }

  @override
  Filter create(FilterRef ref) {
    final _$cb = _createCb ?? filter;
    return _$cb(ref);
  }
}

String _$filterHash() => r'db6b594dad9378c59a08eaee9a1208065cb916eb';

typedef FilteredTodosRef = Ref<List<Todo>>;

@ProviderFor(filteredTodos)
const filteredTodosProvider = FilteredTodosProvider._();

final class FilteredTodosProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>>
    with $Provider<List<Todo>, FilteredTodosRef> {
  const FilteredTodosProvider._(
      {List<Todo> Function(
        FilteredTodosRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'filteredTodosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    FilteredTodosRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$filteredTodosHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<List<Todo>> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  FilteredTodosProvider $copyWithCreate(
    List<Todo> Function(
      FilteredTodosRef ref,
    ) create,
  ) {
    return FilteredTodosProvider._(create: create);
  }

  @override
  List<Todo> create(FilteredTodosRef ref) {
    final _$cb = _createCb ?? filteredTodos;
    return _$cb(ref);
  }
}

String _$filteredTodosHash() => r'bcb1e81823aaf9b967948b619c177ebc571d96a7';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
