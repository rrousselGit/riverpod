// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef HelloWorldRef = Ref<String>;

@ProviderFor(helloWorld)
const helloWorldProvider = HelloWorldProvider._();

final class HelloWorldProvider extends $FunctionalProvider<String, String>
    with $Provider<String, HelloWorldRef> {
  const HelloWorldProvider._(
      {String Function(
        HelloWorldRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'helloWorldProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    HelloWorldRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$helloWorldHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  HelloWorldProvider $copyWithCreate(
    String Function(
      HelloWorldRef ref,
    ) create,
  ) {
    return HelloWorldProvider._(create: create);
  }

  @override
  String create(HelloWorldRef ref) {
    final _$cb = _createCb ?? helloWorld;
    return _$cb(ref);
  }
}

String _$helloWorldHash() => r'9abaa5ab530c55186861f2debdaa218aceacb7eb';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
