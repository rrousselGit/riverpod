// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'same_type.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ItemsRef = Ref<List<Item>>;

@ProviderFor(items)
const itemsProvider = ItemsProvider._();

final class ItemsProvider
    extends $FunctionalProvider<List<Item>, List<Item>, ItemsRef>
    with $Provider<List<Item>, ItemsRef> {
  const ItemsProvider._(
      {List<Item> Function(
        ItemsRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'itemsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final List<Item> Function(
    ItemsRef ref,
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
  $ProviderElement<List<Item>> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ItemsProvider $copyWithCreate(
    List<Item> Function(
      ItemsRef ref,
    ) create,
  ) {
    return ItemsProvider._(create: create);
  }

  @override
  List<Item> create(ItemsRef ref) {
    final _$cb = _createCb ?? items;
    return _$cb(ref);
  }
}

String _$itemsHash() => r'f0a8fa6874f4868db9ead31e82c75d976f9d2033';

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

String _$evenItemsHash() => r'82b4525e91604745f2b4664531b32d4aff5717d4';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
