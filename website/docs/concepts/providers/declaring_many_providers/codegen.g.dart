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

String _$cityHash() => r'2ccdee096b5d5c1cafa736b3e52b788431b9af38';

/// See also [city].
final cityProvider = AutoDisposeProvider<String>(
  city,
  name: r'cityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cityHash,
);
typedef CityRef = AutoDisposeProviderRef<String>;
String _$countryHash() => r'd1513349c3bc0c99763cb4fb29eb012f2351bc4c';

/// See also [country].
final countryProvider = AutoDisposeProvider<String>(
  country,
  name: r'countryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countryHash,
);
typedef CountryRef = AutoDisposeProviderRef<String>;
