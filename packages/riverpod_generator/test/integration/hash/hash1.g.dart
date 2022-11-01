// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash1.dart';

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

List<ProviderOrFamily> _allTransitiveDependencies(
  List<ProviderOrFamily> dependencies,
) {
  final result = <ProviderOrFamily>{};

  void visitDependency(ProviderOrFamily dep) {
    if (result.add(dep) && dep.dependencies != null) {
      dep.dependencies!.forEach(visitDependency);
    }
    final depFamily = dep.from;
    if (depFamily != null &&
        result.add(depFamily) &&
        depFamily.dependencies != null) {
      depFamily.dependencies!.forEach(visitDependency);
    }
  }

  dependencies.forEach(visitDependency);

  return List.unmodifiable(result);
}

typedef SimpleClassRef = AutoDisposeNotifierProviderRef<String>;
String $SimpleClassHash() => r'958123cd6179c5b88da040cfeb71eb3061765277';

/// See also [SimpleClass].
final simpleClassProvider = AutoDisposeNotifierProvider<SimpleClass, String>(
  SimpleClass.new,
  name: r'simpleClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $SimpleClassHash,
  dependencies: <ProviderOrFamily>[],
);

abstract class _$SimpleClass extends AutoDisposeNotifier<String> {
  @override
  String build();
}

typedef SimpleRef = AutoDisposeProviderRef<String>;
String $simpleHash() => r'ff9f7451526aef5b3af6646814631a502ad76a5f';

/// See also [simple].
final simpleProvider = AutoDisposeProvider<String>(
  simple,
  name: r'simpleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $simpleHash,
  dependencies: <ProviderOrFamily>[],
);
typedef Simple2Ref = AutoDisposeProviderRef<String>;
String $simple2Hash() => r'06327442776394c5c9cbb33b048d7a42e709e7fd';

/// See also [simple2].
final simple2Provider = AutoDisposeProvider<String>(
  simple2,
  name: r'simple2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $simple2Hash,
  dependencies: <ProviderOrFamily>[],
);
