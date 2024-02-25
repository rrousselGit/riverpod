// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'another.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef BRef = Ref<int>;

@ProviderFor(b)
const bProvider = BProvider._();

final class BProvider extends $FunctionalProvider<int, int, BRef>
    with $Provider<int, BRef> {
  const BProvider._(
      {int Function(
        BRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'bProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    BRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$bHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  BProvider $copyWithCreate(
    int Function(
      BRef ref,
    ) create,
  ) {
    return BProvider._(create: create);
  }

  @override
  int create(BRef ref) {
    final _$cb = _createCb ?? b;
    return _$cb(ref);
  }
}

String _$bHash() => r'52593050701642f22b31c590f20c003dc2ee1579';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
