// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'combine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FilteredTodosRef = Ref<List<Todo>>;

@ProviderFor(filteredTodos)
const filteredTodosProvider = FilteredTodosProvider._();

final class FilteredTodosProvider
    extends $FunctionalProvider<List<Todo>, List<Todo>, FilteredTodosRef>
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

  @override
  $ProviderElement<List<Todo>> createElement(ProviderContainer container) =>
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

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
