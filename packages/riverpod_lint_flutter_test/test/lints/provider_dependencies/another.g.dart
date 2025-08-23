// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'another.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(b)
const bProvider = BProvider._();

final class BProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const BProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return b(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$bHash() => r'31624e9aa10c9cd7941c9626e841c6df3468723b';

@ProviderFor(anotherScoped)
const anotherScopedProvider = AnotherScopedProvider._();

final class AnotherScopedProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const AnotherScopedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'anotherScopedProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$anotherScopedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return anotherScoped(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$anotherScopedHash() => r'edf3ccffb7c3ce1b1e4ffdd4009aeed4fa38c3f8';

@ProviderFor(anotherNonEmptyScoped)
const anotherNonEmptyScopedProvider = AnotherNonEmptyScopedProvider._();

final class AnotherNonEmptyScopedProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const AnotherNonEmptyScopedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'anotherNonEmptyScopedProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[anotherScopedProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          AnotherNonEmptyScopedProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = anotherScopedProvider;

  @override
  String debugGetCreateSourceHash() => _$anotherNonEmptyScopedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return anotherNonEmptyScoped(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$anotherNonEmptyScopedHash() =>
    r'56da5331e55d74e8e10ff710d20618f217394a69';
