// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator.dart';

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

String _$simpleHash() => r'194188f00eacfa1466fd45ce1523ff73e4a1dd8a';

/// See also [simple].
final simpleProvider = AutoDisposeProvider<int>(
  simple,
  name: r'simpleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$simpleHash,
);
typedef SimpleRef = AutoDisposeProviderRef<int>;
String _$simpleClassHash() => r'f62dc4646fa1c6c5ef6c578a8a7a0910df82e58a';

/// Hello world
///
/// Copied from [simpleClass].
final simpleClassProvider = AutoDisposeProvider<int>(
  simpleClass,
  name: r'simpleClassProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$simpleClassHash,
);
typedef SimpleClassRef = AutoDisposeProviderRef<int>;
