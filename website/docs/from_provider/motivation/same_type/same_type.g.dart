// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'same_type.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(items)
const itemsProvider = ItemsProvider._();

final class ItemsProvider extends $FunctionalProvider<List<Item>, List<Item>>
    with $Provider<List<Item>> {
  const ItemsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'itemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$itemsHash();

  @$internal
  @override
  $ProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Item> create(Ref ref) {
    return items(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Item> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Item>>(value),
    );
  }
}

String _$itemsHash() => r'8dafed1afc3fc52651c24445640d8b57ff080f66';

@ProviderFor(evenItems)
const evenItemsProvider = EvenItemsProvider._();

final class EvenItemsProvider
    extends $FunctionalProvider<List<Item>, List<Item>>
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
      providerOverride: $ValueProvider<List<Item>>(value),
    );
  }
}

String _$evenItemsHash() => r'83ef608e2e1ec6926495f7a4dd4bac3e6b1f16e1';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
