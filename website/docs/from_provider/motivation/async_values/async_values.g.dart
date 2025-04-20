// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_values.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(itemsApi)
const itemsApiProvider = ItemsApiProvider._();

final class ItemsApiProvider
    extends $FunctionalProvider<AsyncValue<List<Item>>, FutureOr<List<Item>>>
    with $FutureModifier<List<Item>>, $FutureProvider<List<Item>> {
  const ItemsApiProvider._(
      {FutureOr<List<Item>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'itemsApiProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<Item>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$itemsApiHash();

  @$internal
  @override
  $FutureProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  ItemsApiProvider $copyWithCreate(
    FutureOr<List<Item>> Function(
      Ref ref,
    ) create,
  ) {
    return ItemsApiProvider._(create: create);
  }

  @override
  FutureOr<List<Item>> create(Ref ref) {
    final _$cb = _createCb ?? itemsApi;
    return _$cb(ref);
  }
}

String _$itemsApiHash() => r'fa5a8f7e93ac048d9bd5dfc1744749995cf154af';

@ProviderFor(evenItems)
const evenItemsProvider = EvenItemsProvider._();

final class EvenItemsProvider
    extends $FunctionalProvider<List<Item>, List<Item>>
    with $Provider<List<Item>> {
  const EvenItemsProvider._(
      {List<Item> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'evenItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Item> Function(
    Ref ref,
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
  $ProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  EvenItemsProvider $copyWithCreate(
    List<Item> Function(
      Ref ref,
    ) create,
  ) {
    return EvenItemsProvider._(create: create);
  }

  @override
  List<Item> create(Ref ref) {
    final _$cb = _createCb ?? evenItems;
    return _$cb(ref);
  }
}

String _$evenItemsHash() => r'22297e33c5f55ff99fb49747c203be595a28fabf';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
