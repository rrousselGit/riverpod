// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose.dart';

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

String $keepAliveHash() => r'72dd192676126d487c24c7695a91d59410c62696';

/// See also [keepAlive].
final keepAliveProvider = Provider<int>(
  keepAlive,
  name: r'keepAliveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $keepAliveHash,
);
typedef KeepAliveRef = ProviderRef<int>;
String $notKeepAliveHash() => r'1ccc497d7c651f8e730ec1bcecf271ffe9615d83';

/// See also [notKeepAlive].
final notKeepAliveProvider = AutoDisposeProvider<int>(
  notKeepAlive,
  name: r'notKeepAliveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $notKeepAliveHash,
);
typedef NotKeepAliveRef = AutoDisposeProviderRef<int>;
