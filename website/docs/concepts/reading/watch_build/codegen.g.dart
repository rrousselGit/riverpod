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

String _$TodoListHash() => r'77f007cd4f5105330a4c2ab8555ea0d1716945c1';

/// See also [TodoList].
final todoListProvider = AutoDisposeNotifierProvider<TodoList, List<Todo>>(
  TodoList.new,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$TodoListHash,
);
typedef TodoListRef = AutoDisposeNotifierProviderRef<List<Todo>>;

abstract class _$TodoList extends AutoDisposeNotifier<List<Todo>> {
  @override
  List<Todo> build();
}

String _$counterHash() => r'9b0db44ecc47057e79891e5ecd92d34b08637679';

/// See also [counter].
final counterProvider = AutoDisposeProvider<int>(
  counter,
  name: r'counterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$counterHash,
);
typedef CounterRef = AutoDisposeProviderRef<int>;
