// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String _$TodosHash() => r'b66ac2b1e5cf7ac7957d25864cfdffad1af233a6';

/// See also [Todos].
final todosProvider = AutoDisposeNotifierProvider<Todos, List<Todo>>(
  Todos.new,
  name: r'todosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$TodosHash,
);
typedef TodosRef = AutoDisposeNotifierProviderRef<List<Todo>>;

abstract class _$Todos extends AutoDisposeNotifier<List<Todo>> {
  @override
  List<Todo> build();
}

String _$filterTypeHash() => r'42b68b163daecff7a0b9b069b16025a89910b4fb';

/// See also [filterType].
final filterTypeProvider = AutoDisposeProvider<FilterType>(
  filterType,
  name: r'filterTypeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filterTypeHash,
);
typedef FilterTypeRef = AutoDisposeProviderRef<FilterType>;
String _$filteredTodoListHash() => r'34f1e929a9e7850946ea8634d9f3e8f38ae5687d';

/// See also [filteredTodoList].
final filteredTodoListProvider = AutoDisposeProvider<List<Todo>>(
  filteredTodoList,
  name: r'filteredTodoListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTodoListHash,
);
typedef FilteredTodoListRef = AutoDisposeProviderRef<List<Todo>>;
