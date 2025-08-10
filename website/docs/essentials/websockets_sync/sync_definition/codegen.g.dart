// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(synchronousExample)
const synchronousExampleProvider = SynchronousExampleProvider._();

final class SynchronousExampleProvider
    extends $FunctionalProvider<int, int, int> with $Provider<int> {
  const SynchronousExampleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'synchronousExampleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$synchronousExampleHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return synchronousExample(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$synchronousExampleHash() =>
    r'a12577c395d5a639fdad88b28309f378a64bd2a7';
