// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(filterType)
const filterTypeProvider = FilterTypeProvider._();

final class FilterTypeProvider
    extends $FunctionalProvider<FilterType, FilterType, FilterType>
    with $Provider<FilterType> {
  const FilterTypeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filterTypeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filterTypeHash();

  @$internal
  @override
  $ProviderElement<FilterType> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FilterType create(Ref ref) {
    return filterType(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilterType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<FilterType, FilterType>(value),
    );
  }
}

String _$filterTypeHash() => r'68d61a593d49306927c26fbcc66ea9fffa7c52f5';

@ProviderFor(Todos)
const todosProvider = TodosProvider._();

final class TodosProvider extends $NotifierProvider<Todos, List<Todo>> {
  const TodosProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todosProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todosHash();

  @$internal
  @override
  Todos create() => Todos();

  @$internal
  @override
  $NotifierProviderElement<Todos, List<Todo>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>, List<Todo>>(value),
    );
  }
}

String _$todosHash() => r'b66ac2b1e5cf7ac7957d25864cfdffad1af233a6';

abstract class _$Todos extends $Notifier<List<Todo>> {
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

@ProviderFor(filteredTodoList)
const filteredTodoListProvider = FilteredTodoListProvider._();

final class FilteredTodoListProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>, List<Todo>>
    with $Provider<List<Todo>> {
  const FilteredTodoListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredTodoListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filteredTodoListHash();

  @$internal
  @override
  $ProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Todo> create(Ref ref) {
    return filteredTodoList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Todo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Todo>, List<Todo>>(value),
    );
  }
}

String _$filteredTodoListHash() => r'0508935737f2cb9718bd8150111135cb433bfaeb';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
