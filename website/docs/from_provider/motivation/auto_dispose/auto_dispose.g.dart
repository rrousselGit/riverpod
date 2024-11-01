// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'auto_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(diceRoll)
const diceRollProvider = DiceRollProvider._();

final class DiceRollProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DiceRollProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'diceRollProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$diceRollHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  DiceRollProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return DiceRollProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? diceRoll;
    return _$cb(ref);
  }
}

String _$diceRollHash() => r'58d43e5143bb64e855939d55a3be3ee81d66c518';

@ProviderFor(cachedDiceRoll)
const cachedDiceRollProvider = CachedDiceRollProvider._();

final class CachedDiceRollProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const CachedDiceRollProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'cachedDiceRollProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$cachedDiceRollHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  CachedDiceRollProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return CachedDiceRollProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? cachedDiceRoll;
    return _$cb(ref);
  }
}

String _$cachedDiceRollHash() => r'eaf5bb809278298f16e2eda8972b1876921f66f5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
