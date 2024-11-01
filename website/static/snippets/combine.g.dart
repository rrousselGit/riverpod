// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'combine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(todos)
const todosProvider = TodosProvider._();

final class TodosProvider extends $FunctionalProvider<List<Todo>, List<Todo>>
    with $Provider<List<Todo>> {
  const TodosProvider._(
      {List<Todo> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'todosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    Ref ref,
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
  $ProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  TodosProvider $copyWithCreate(
    List<Todo> Function(
      Ref ref,
    ) create,
  ) {
    return TodosProvider._(create: create);
  }

  @override
  List<Todo> create(Ref ref) {
    final _$cb = _createCb ?? todos;
    return _$cb(ref);
  }
}

String _$todosHash() => r'ed255140669430745a7779b542a1209dc182ce0c';

@ProviderFor(filter)
const filterProvider = FilterProvider._();

final class FilterProvider extends $FunctionalProvider<Filter, Filter>
    with $Provider<Filter> {
  const FilterProvider._(
      {Filter Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'filterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Filter Function(
    Ref ref,
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
  $ProviderElement<Filter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FilterProvider $copyWithCreate(
    Filter Function(
      Ref ref,
    ) create,
  ) {
    return FilterProvider._(create: create);
  }

  @override
  Filter create(Ref ref) {
    final _$cb = _createCb ?? filter;
    return _$cb(ref);
  }
}

String _$filterHash() => r'38c5f61dc2d4b44e9be37bb724487d265cc0a645';

@ProviderFor(filteredTodos)
const filteredTodosProvider = FilteredTodosProvider._();

final class FilteredTodosProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>>
    with $Provider<List<Todo>> {
  const FilteredTodosProvider._(
      {List<Todo> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredTodosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    Ref ref,
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
  $ProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FilteredTodosProvider $copyWithCreate(
    List<Todo> Function(
      Ref ref,
    ) create,
  ) {
    return FilteredTodosProvider._(create: create);
  }

  @override
  List<Todo> create(Ref ref) {
    final _$cb = _createCb ?? filteredTodos;
    return _$cb(ref);
  }
}

String _$filteredTodosHash() => r'9a243c7679a9c6c6aa4a9bea798cbff31a3038c6';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
