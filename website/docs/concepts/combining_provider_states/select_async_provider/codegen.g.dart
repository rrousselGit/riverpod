// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(config)
const configProvider = ConfigProvider._();

final class ConfigProvider extends $FunctionalProvider<
        AsyncValue<Configuration>, Stream<Configuration>>
    with $FutureModifier<Configuration>, $StreamProvider<Configuration> {
  const ConfigProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'configProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$configHash();

  @$internal
  @override
  $StreamProviderElement<Configuration> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Configuration> create(Ref ref) {
    return config(ref);
  }
}

String _$configHash() => r'66f48a02bf939463649f0e7ad34137265e5c8b66';

@ProviderFor(products)
const productsProvider = ProductsProvider._();

final class ProductsProvider extends $FunctionalProvider<
        AsyncValue<List<Product>>, FutureOr<List<Product>>>
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return products(ref);
  }
}

String _$productsHash() => r'1915c65cef29cadc8b0adadd6ecddf753586974b';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
