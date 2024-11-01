// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ConfigRef = Ref<AsyncValue<Configuration>>;

@ProviderFor(config)
const configProvider = ConfigProvider._();

final class ConfigProvider extends $FunctionalProvider<
        AsyncValue<Configuration>, Stream<Configuration>>
    with
        $FutureModifier<Configuration>,
        $StreamProvider<Configuration, ConfigRef> {
  const ConfigProvider._(
      {Stream<Configuration> Function(
        ConfigRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'configProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<Configuration> Function(
    ConfigRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$configHash();

  @$internal
  @override
  $StreamProviderElement<Configuration> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

  @override
  ConfigProvider $copyWithCreate(
    Stream<Configuration> Function(
      ConfigRef ref,
    ) create,
  ) {
    return ConfigProvider._(create: create);
  }

  @override
  Stream<Configuration> create(ConfigRef ref) {
    final _$cb = _createCb ?? config;
    return _$cb(ref);
  }
}

String _$configHash() => r'66f48a02bf939463649f0e7ad34137265e5c8b66';

typedef ProductsRef = Ref<AsyncValue<List<Product>>>;

@ProviderFor(products)
const productsProvider = ProductsProvider._();

final class ProductsProvider extends $FunctionalProvider<
        AsyncValue<List<Product>>, FutureOr<List<Product>>>
    with
        $FutureModifier<List<Product>>,
        $FutureProvider<List<Product>, ProductsRef> {
  const ProductsProvider._(
      {FutureOr<List<Product>> Function(
        ProductsRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'productsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<Product>> Function(
    ProductsRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  ProductsProvider $copyWithCreate(
    FutureOr<List<Product>> Function(
      ProductsRef ref,
    ) create,
  ) {
    return ProductsProvider._(create: create);
  }

  @override
  FutureOr<List<Product>> create(ProductsRef ref) {
    final _$cb = _createCb ?? products;
    return _$cb(ref);
  }
}

String _$productsHash() => r'd0ddbfac09629b48b568f0cc07e063bb7d649162';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
