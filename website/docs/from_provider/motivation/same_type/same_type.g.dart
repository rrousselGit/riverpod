// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'same_type.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(items)
final itemsProvider = ItemsProvider._();

final class ItemsProvider
    extends $FunctionalProvider<List<Item>, List<Item>, List<Item>>
    with $Provider<List<Item>> {
  ItemsProvider._()
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
      providerOverride: $SyncValueProvider<List<Item>>(value),
    );
  }
}

String _$itemsHash() => r'8dafed1afc3fc52651c24445640d8b57ff080f66';

@ProviderFor(evenItems)
final evenItemsProvider = EvenItemsProvider._();

final class EvenItemsProvider
    extends $FunctionalProvider<List<Item>, List<Item>, List<Item>>
    with $Provider<List<Item>> {
  EvenItemsProvider._()
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

String _$evenItemsHash() => r'83ef608e2e1ec6926495f7a4dd4bac3e6b1f16e1';
