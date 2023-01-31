// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unoptimized_previous_button.dart';

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

String _$PageIndexHash() => r'59307ecf23b5b2432833da5ad6b312bf36435d0e';

/// See also [PageIndex].
final pageIndexProvider = AutoDisposeNotifierProvider<PageIndex, int>(
  PageIndex.new,
  name: r'pageIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$PageIndexHash,
);
typedef PageIndexRef = AutoDisposeNotifierProviderRef<int>;

abstract class _$PageIndex extends AutoDisposeNotifier<int> {
  @override
  int build();
}
