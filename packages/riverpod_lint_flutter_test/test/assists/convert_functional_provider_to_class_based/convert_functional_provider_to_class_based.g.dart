// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_functional_provider_to_class_based.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Some comment
@ProviderFor(example)
const exampleProvider = ExampleProvider._();

/// Some comment
final class ExampleProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Some comment
  const ExampleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return example(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int, int>(value),
    );
  }
}

String _$exampleHash() => r'67898608b444d39a000852f647ca6d3326740c98';

/// Some comment
@ProviderFor(exampleFamily)
const exampleFamilyProvider = ExampleFamilyFamily._();

/// Some comment
final class ExampleFamilyProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Some comment
  const ExampleFamilyProvider._(
      {required ExampleFamilyFamily super.from,
      required ({
        int a,
        String b,
      })
          super.argument})
      : super(
          retry: null,
          name: r'exampleFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exampleFamilyHash();

  @override
  String toString() {
    return r'exampleFamilyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as ({
      int a,
      String b,
    });
    return exampleFamily(
      ref,
      a: argument.a,
      b: argument.b,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int, int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleFamilyHash() => r'70dfc6f4b2d7d251edbc3a66c3ac0f2c56aebf8b';

/// Some comment
final class ExampleFamilyFamily extends $Family
    with
        $FunctionalFamilyOverride<
            int,
            ({
              int a,
              String b,
            })> {
  const ExampleFamilyFamily._()
      : super(
          retry: null,
          name: r'exampleFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Some comment
  ExampleFamilyProvider call({
    required int a,
    String b = '42',
  }) =>
      ExampleFamilyProvider._(argument: (
        a: a,
        b: b,
      ), from: this);

  @override
  String toString() => r'exampleFamilyProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
