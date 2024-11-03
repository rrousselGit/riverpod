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
  const ItemsProvider._(
      {List<Item> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'itemsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Item> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$itemsHash();

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
  ItemsProvider $copyWithCreate(
    List<Item> Function(
      Ref ref,
    ) create,
  ) {
    return ItemsProvider._(create: create);
  }

  @override
  List<Item> create(Ref ref) {
    final _$cb = _createCb ?? items;
    return _$cb(ref);
  }
}

String _$itemsHash() => r'8dafed1afc3fc52651c24445640d8b57ff080f66';

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

String _$evenItemsHash() => r'83ef608e2e1ec6926495f7a4dd4bac3e6b1f16e1';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
