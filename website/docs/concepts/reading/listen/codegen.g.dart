// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef AnotherRef = Ref<void>;

@ProviderFor(another)
const anotherProvider = AnotherProvider._();

final class AnotherProvider extends $FunctionalProvider<void, void, AnotherRef>
    with $Provider<void, AnotherRef> {
  const AnotherProvider._(
      {void Function(
        AnotherRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'anotherProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final void Function(
    AnotherRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$anotherHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<void> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AnotherProvider $copyWithCreate(
    void Function(
      AnotherRef ref,
    ) create,
  ) {
    return AnotherProvider._(create: create);
  }

  @override
  void create(AnotherRef ref) {
    final _$cb = _createCb ?? another;
    return _$cb(ref);
  }
}

String _$anotherHash() => r'2208f9221f3d898305609874d4f43c28bdfff2b4';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
