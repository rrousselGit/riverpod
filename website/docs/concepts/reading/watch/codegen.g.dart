// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(filterType)
const filterTypeProvider = FilterTypeProvider._();

final class FilterTypeProvider
    extends $FunctionalProvider<FilterType, FilterType>
    with $Provider<FilterType> {
  const FilterTypeProvider._(
      {FilterType Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'filterTypeProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FilterType Function(
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return FilterTypeProvider._(create: create);
  }

  @override
  FilterType create(Ref ref) {
    final _$cb = _createCb ?? filterType;
    return _$cb(ref);
  }
}

String _$filterTypeHash() => r'68d61a593d49306927c26fbcc66ea9fffa7c52f5';

@ProviderFor(Todos)
const todosProvider = TodosProvider._();

final class TodosProvider extends $NotifierProvider<Todos, List<Todo>> {
  const TodosProvider._(
      {super.runNotifierBuildOverride, Todos Function()? create})
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
      Ref,
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
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Todo>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<List<Todo>>, List<Todo>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredTodoList)
const filteredTodoListProvider = FilteredTodoListProvider._();

final class FilteredTodoListProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>>
    with $Provider<List<Todo>> {
  const FilteredTodoListProvider._(
      {List<Todo> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredTodoListProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Todo> Function(
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return FilteredTodoListProvider._(create: create);
  }

  @override
  List<Todo> create(Ref ref) {
    final _$cb = _createCb ?? filteredTodoList;
    return _$cb(ref);
  }
}

String _$filteredTodoListHash() => r'0508935737f2cb9718bd8150111135cb433bfaeb';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
