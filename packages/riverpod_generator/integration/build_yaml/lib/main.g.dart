// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// Generator: RiverpodGenerator2
// **************************************************************************

// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment
String _$countNotifierHash() => 'a8dd7a66ee0002b8af657245c4affaa206fd99ec';

/// See also [CountNotifier].
@ProviderFor(CountNotifier)
final countNotifierPod = AutoDisposeNotifierProvider<CountNotifier, int>(
  CountNotifier.new,
  name: r'countNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countNotifierHash,
);

typedef _$CountNotifier = AutoDisposeNotifier<int>;
String _$countAsyncNotifierHash() => '2a7049d864bf396e44a5937b4001efb4774a5f29';

/// See also [CountAsyncNotifier].
@ProviderFor(CountAsyncNotifier)
final countAsyncNotifierPod =
    AutoDisposeAsyncNotifierProvider<CountAsyncNotifier, int>(
  CountAsyncNotifier.new,
  name: r'countAsyncNotifierPod',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countAsyncNotifierHash,
);

typedef _$CountAsyncNotifier = AutoDisposeAsyncNotifier<int>;
String _$countHash() => '4c7e72b275767a60ece5e8662ab1e28f73cf7e44';

/// See also [count].
@ProviderFor(count)
final countPod = AutoDisposeProvider<int>(
  count,
  name: r'countPod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countHash,
);

typedef CountRef = AutoDisposeProviderRef<int>;
String _$countFutureHash() => 'ec7cc31ce1c1a10607f1dcb35dd217acd2877729';

/// See also [countFuture].
@ProviderFor(countFuture)
final countFuturePod = AutoDisposeFutureProvider<int>(
  countFuture,
  name: r'countFuturePod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countFutureHash,
);

typedef CountFutureRef = AutoDisposeFutureProviderRef<int>;
