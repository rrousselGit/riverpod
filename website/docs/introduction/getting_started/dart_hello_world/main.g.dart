// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(helloWorld)
const helloWorldProvider = HelloWorldProvider._();

final class HelloWorldProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  const HelloWorldProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'helloWorldProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$helloWorldHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return helloWorld(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String, String>(value),
    );
  }
}

String _$helloWorldHash() => r'9abaa5ab530c55186861f2debdaa218aceacb7eb';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
