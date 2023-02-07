// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs
String _$countNotifierHash() => 'a8dd7a66ee0002b8af657245c4affaa206fd99ec';

/// See also [CountNotifier].
@ProviderFor(CountNotifier)
final countNotifierPod =
    AutoDisposeNotifierProvider<CountNotifier, int>.internal(
  CountNotifier.new,
  name: r'countNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CountNotifier = AutoDisposeNotifier<int>;
String _$countAsyncNotifierHash() => '2a7049d864bf396e44a5937b4001efb4774a5f29';

/// See also [CountAsyncNotifier].
@ProviderFor(CountAsyncNotifier)
final countAsyncNotifierPod =
    AutoDisposeAsyncNotifierProvider<CountAsyncNotifier, int>.internal(
  CountAsyncNotifier.new,
  name: r'countAsyncNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countAsyncNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CountAsyncNotifier = AutoDisposeAsyncNotifier<int>;
String _$countHash() => '4c7e72b275767a60ece5e8662ab1e28f73cf7e44';

/// See also [count].
@ProviderFor(count)
final countPod = AutoDisposeProvider<int>.internal(
  count,
  name: r'countPod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CountRef = AutoDisposeProviderRef<int>;
String _$countFutureHash() => 'ec7cc31ce1c1a10607f1dcb35dd217acd2877729';

/// See also [countFuture].
@ProviderFor(countFuture)
final countFuturePod = AutoDisposeFutureProvider<int>.internal(
  countFuture,
  name: r'countFuturePod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CountFutureRef = AutoDisposeFutureProviderRef<int>;
