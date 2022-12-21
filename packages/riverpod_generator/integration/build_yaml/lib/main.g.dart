// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

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

String _$CountNotifierHash() => r'a8dd7a66ee0002b8af657245c4affaa206fd99ec';

/// See also [CountNotifier].
final countNotifierPod = AutoDisposeNotifierProvider<CountNotifier, int>(
  CountNotifier.new,
  name: r'countNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$CountNotifierHash,
);
typedef CountNotifierRef = AutoDisposeNotifierProviderRef<int>;

abstract class _$CountNotifier extends AutoDisposeNotifier<int> {
  @override
  int build();
}

String _$CountAsyncNotifierHash() =>
    r'2a7049d864bf396e44a5937b4001efb4774a5f29';

/// See also [CountAsyncNotifier].
final countAsyncNotifierPod =
    AutoDisposeAsyncNotifierProvider<CountAsyncNotifier, int>(
  CountAsyncNotifier.new,
  name: r'countAsyncNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$CountAsyncNotifierHash,
);
typedef CountAsyncNotifierRef = AutoDisposeAsyncNotifierProviderRef<int>;

abstract class _$CountAsyncNotifier extends AutoDisposeAsyncNotifier<int> {
  @override
  FutureOr<int> build();
}

String _$countHash() => r'4c7e72b275767a60ece5e8662ab1e28f73cf7e44';

/// See also [count].
final countPod = AutoDisposeProvider<int>(
  count,
  name: r'countPod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countHash,
);
typedef CountRef = AutoDisposeProviderRef<int>;
String _$countFutureHash() => r'ec7cc31ce1c1a10607f1dcb35dd217acd2877729';

/// See also [countFuture].
final countFuturePod = AutoDisposeFutureProvider<int>(
  countFuture,
  name: r'countFuturePod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countFutureHash,
);
typedef CountFutureRef = AutoDisposeFutureProviderRef<int>;
