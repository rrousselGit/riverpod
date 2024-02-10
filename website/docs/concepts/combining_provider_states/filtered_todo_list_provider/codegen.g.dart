// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FilteredTodoListRef = Ref<List<Todo>>;

@ProviderFor(filteredTodoList)
const filteredTodoListProvider = FilteredTodoListProvider._();

final class FilteredTodoListProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>, FilteredTodoListRef>
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

  @override
  $ProviderElement<List<Todo>> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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

String _$filteredTodoListHash() => r'1c35eb0fce8fc7c7cda86413b02f606f8c8ae2b4';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
