// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefixed_functional_ref.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prefixedRef)
final prefixedRefProvider = PrefixedRefProvider._();

final class PrefixedRefProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  PrefixedRefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefixedRefProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefixedRefHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return prefixedRef(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$prefixedRefHash() => r'a24b4ced9012361b5a4f056aef7fc969b4ae796b';
