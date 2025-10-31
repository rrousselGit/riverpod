// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(random)
final randomProvider = RandomFamily._();

final class RandomProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  RandomProvider._({
    required RandomFamily super.from,
    required ({int seed, int max}) super.argument,
  }) : super(
         retry: null,
         name: r'randomProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$randomHash();

  @override
  String toString() {
    return r'randomProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as ({int seed, int max});
    return random(ref, seed: argument.seed, max: argument.max);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RandomProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$randomHash() => r'ab69799dce84746b22880feae0f1db6dea906f6a';

final class RandomFamily extends $Family
    with $FunctionalFamilyOverride<int, ({int seed, int max})> {
  RandomFamily._()
    : super(
        retry: null,
        name: r'randomProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RandomProvider call({required int seed, required int max}) =>
      RandomProvider._(argument: (seed: seed, max: max), from: this);

  @override
  String toString() => r'randomProvider';
}
