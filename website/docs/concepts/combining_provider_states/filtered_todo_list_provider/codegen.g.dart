// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

String _$filterHash() => r'6583f8bace972f4385964cd26f217751164b537b';

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

String _$filteredTodoListHash() => r'e0faf3934cd30a62b5771f2e4d64eaa727065c2f';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
