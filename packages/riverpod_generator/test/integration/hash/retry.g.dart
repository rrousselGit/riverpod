// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(a)
const aProvider = AProvider._();

final class AProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const AProvider._()
      : super(
          from: null,
          argument: null,
          retry: myRetry,
          name: r'aProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return a(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$aHash() => r'83a9516d10f85dc72ca773837e042bfc6e36c1f1';

@ProviderFor(b)
const bProvider = BFamily._();

final class BProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const BProvider._({required BFamily super.from, required int super.argument})
      : super(
          retry: myRetry2,
          name: r'bProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bHash();

  @override
  String toString() {
    return r'bProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as int;
    return b(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bHash() => r'95798a157250c86a901bca5701b487f508f8a5a4';

final class BFamily extends $Family
    with $FunctionalFamilyOverride<String, int> {
  const BFamily._()
      : super(
          retry: myRetry2,
          name: r'bProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BProvider call(
    int arg,
  ) =>
      BProvider._(argument: arg, from: this);

  @override
  String toString() => r'bProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
