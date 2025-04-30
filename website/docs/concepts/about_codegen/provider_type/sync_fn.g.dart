// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'sync_fn.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
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
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return example(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$exampleHash() => r'e75fe2037fef7a3f80e04fa007fe64d719dba2fd';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
