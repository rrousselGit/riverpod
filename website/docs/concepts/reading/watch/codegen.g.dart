// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FilterTypeRef = Ref<FilterType>;

@ProviderFor(filterType)
const filterTypeProvider = FilterTypeProvider._();

final class FilterTypeProvider
    extends $FunctionalProvider<FilterType, FilterType>
    with $Provider<FilterType, FilterTypeRef> {
  const FilterTypeProvider._(
      {FilterType Function(
        FilterTypeRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'filterTypeProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FilterType Function(
    FilterTypeRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$filterTypeHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilterType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<FilterType>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<FilterType> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FilterTypeProvider $copyWithCreate(
    FilterType Function(
      FilterTypeRef ref,
    ) create,
  ) {
    return FilterTypeProvider._(create: create);
  }

  @override
  FilterType create(FilterTypeRef ref) {
    final _$cb = _createCb ?? filterType;
    return _$cb(ref);
  }
}

String _$filterTypeHash() => r'42b68b163daecff7a0b9b069b16025a89910b4fb';

@ProviderFor(Todos)
const todosProvider = TodosProvider._();

final class TodosProvider extends $NotifierProvider<Todos, List<Todo>> {
  const TodosProvider._(
      {super.runNotifierBuildOverride, Todos Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'todosProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Todos Function()? _createCb;

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
  Todos create() => _createCb?.call() ?? Todos();

  @$internal
  @override
  TodosProvider $copyWithCreate(
    Todos Function() create,
  ) {
    return TodosProvider._(create: create);
  }

  @$internal
  @override
  TodosProvider $copyWithBuild(
    List<Todo> Function(
      Ref<List<Todo>>,
      Todos,
    ) build,
  ) {
    return TodosProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Todos, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$todosHash() => r'b66ac2b1e5cf7ac7957d25864cfdffad1af233a6';

abstract class _$Todos extends $Notifier<List<Todo>> {
  List<Todo> build();
  @$internal
  @override
  List<Todo> runBuild() => build();
}

typedef FilteredTodoListRef = Ref<List<Todo>>;

@ProviderFor(filteredTodoList)
const filteredTodoListProvider = FilteredTodoListProvider._();

final class FilteredTodoListProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>>
    with $Provider<List<Todo>, FilteredTodoListRef> {
  const FilteredTodoListProvider._(
      {List<Todo> Function(
        FilteredTodoListRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'filteredTodoListProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    FilteredTodoListRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$filteredTodoListHash();

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
  FilteredTodoListProvider $copyWithCreate(
    List<Todo> Function(
      FilteredTodoListRef ref,
    ) create,
  ) {
    return FilteredTodoListProvider._(create: create);
  }

  @override
  List<Todo> create(FilteredTodoListRef ref) {
    final _$cb = _createCb ?? filteredTodoList;
    return _$cb(ref);
  }
}

String _$filteredTodoListHash() => r'34f1e929a9e7850946ea8634d9f3e8f38ae5687d';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
