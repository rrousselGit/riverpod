// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose.dart';

// **************************************************************************
// Generator: RiverpodGenerator2
// **************************************************************************

// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment
String _$keepAliveHash() => '72dd192676126d487c24c7695a91d59410c62696';

/// See also [keepAlive].
@ProviderFor(keepAlive)
final keepAliveProvider = Provider<int>(
  keepAlive,
  name: r'keepAliveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$keepAliveHash,
);

typedef KeepAliveRef = ProviderRef<int>;
String _$notKeepAliveHash() => '1ccc497d7c651f8e730ec1bcecf271ffe9615d83';

/// See also [notKeepAlive].
@ProviderFor(notKeepAlive)
final notKeepAliveProvider = AutoDisposeProvider<int>(
  notKeepAlive,
  name: r'notKeepAliveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$notKeepAliveHash,
);

typedef NotKeepAliveRef = AutoDisposeProviderRef<int>;
