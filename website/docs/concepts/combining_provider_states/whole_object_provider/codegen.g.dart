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
        AsyncValue<Configuration>, Stream<Configuration>, ConfigRef>
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
          ProviderContainer container) =>
      $StreamProviderElement(this, container);

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

String _$configHash() => r'3021d1a8aac384e99d5d22714ffe6e868954888b';

typedef ProductsRef = Ref<AsyncValue<List<Product>>>;

@ProviderFor(products)
const productsProvider = ProductsProvider._();

final class ProductsProvider extends $FunctionalProvider<
        AsyncValue<List<Product>>, FutureOr<List<Product>>, ProductsRef>
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
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

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

String _$productsHash() => r'637254615fa398af0d36e212f09e5d3d8ff866aa';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
