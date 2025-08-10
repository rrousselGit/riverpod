// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_values.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(itemsApi)
const itemsApiProvider = ItemsApiProvider._();

final class ItemsApiProvider extends $FunctionalProvider<AsyncValue<List<Item>>,
        List<Item>, FutureOr<List<Item>>>
    with $FutureModifier<List<Item>>, $FutureProvider<List<Item>> {
  const ItemsApiProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'itemsApiProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$itemsApiHash();

  @$internal
  @override
  $FutureProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Item>> create(Ref ref) {
    return itemsApi(ref);
  }
}

String _$itemsApiHash() => r'fa5a8f7e93ac048d9bd5dfc1744749995cf154af';

@ProviderFor(evenItems)
const evenItemsProvider = EvenItemsProvider._();

final class EvenItemsProvider
    extends $FunctionalProvider<List<Item>, List<Item>, List<Item>>
    with $Provider<List<Item>> {
  const EvenItemsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'evenItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$evenItemsHash();

  @$internal
  @override
  $ProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Item> create(Ref ref) {
    return evenItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Item> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Item>>(value),
    );
  }
}

String _$evenItemsHash() => r'22297e33c5f55ff99fb49747c203be595a28fabf';
