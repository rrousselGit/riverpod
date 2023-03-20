// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configHash() => r'3021d1a8aac384e99d5d22714ffe6e868954888b';

/// See also [config].
@ProviderFor(config)
final configProvider = AutoDisposeStreamProvider<Configuration>.internal(
  config,
  name: r'configProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$configHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConfigRef = AutoDisposeStreamProviderRef<Configuration>;
String _$productsHash() => r'85b52bc6b95afadccaf19c337e6dd096c5f1d791';

/// See also [products].
@ProviderFor(products)
final productsProvider = AutoDisposeFutureProvider<List<Product>>.internal(
  products,
  name: r'productsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsRef = AutoDisposeFutureProviderRef<List<Product>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
