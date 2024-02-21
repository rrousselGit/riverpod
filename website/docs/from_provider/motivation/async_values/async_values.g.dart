// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_values.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ItemsApiRef = Ref<AsyncValue<List<Item>>>;

@ProviderFor(itemsApi)
const itemsApiProvider = ItemsApiProvider._();

final class ItemsApiProvider extends $FunctionalProvider<AsyncValue<List<Item>>,
        FutureOr<List<Item>>, ItemsApiRef>
    with $FutureModifier<List<Item>>, $FutureProvider<List<Item>, ItemsApiRef> {
  const ItemsApiProvider._(
      {FutureOr<List<Item>> Function(
        ItemsApiRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'itemsApiProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<Item>> Function(
    ItemsApiRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$itemsApiHash();

  @$internal
  @override
  $FutureProviderElement<List<Item>> $createElement(
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

  @override
  ItemsApiProvider $copyWithCreate(
    FutureOr<List<Item>> Function(
      ItemsApiRef ref,
    ) create,
  ) {
    return ItemsApiProvider._(create: create);
  }

  @override
  FutureOr<List<Item>> create(ItemsApiRef ref) {
    final _$cb = _createCb ?? itemsApi;
    return _$cb(ref);
  }
}

String _$itemsApiHash() => r'b32ccb7b85305e361d8ed752cbe11d9524c96190';

typedef EvenItemsRef = Ref<List<Item>>;

@ProviderFor(evenItems)
const evenItemsProvider = EvenItemsProvider._();

final class EvenItemsProvider
    extends $FunctionalProvider<List<Item>, List<Item>, EvenItemsRef>
    with $Provider<List<Item>, EvenItemsRef> {
  const EvenItemsProvider._(
      {List<Item> Function(
        EvenItemsRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'evenItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Item> Function(
    EvenItemsRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$evenItemsHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Item> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Item>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<List<Item>> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  EvenItemsProvider $copyWithCreate(
    List<Item> Function(
      EvenItemsRef ref,
    ) create,
  ) {
    return EvenItemsProvider._(create: create);
  }

  @override
  List<Item> create(EvenItemsRef ref) {
    final _$cb = _createCb ?? evenItems;
    return _$cb(ref);
  }
}

String _$evenItemsHash() => r'55ae98f9b6108203dfc4a139f1ade9fbd8ba8ddd';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
