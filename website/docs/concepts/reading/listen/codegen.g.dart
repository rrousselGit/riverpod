// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(another)
const anotherProvider = AnotherProvider._();

final class AnotherProvider extends $FunctionalProvider<void, void>
    with $Provider<void> {
  const AnotherProvider._(
      {void Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'anotherProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final void Function(
    Ref ref,
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
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  AnotherProvider $copyWithCreate(
    void Function(
      Ref ref,
    ) create,
  ) {
    return AnotherProvider._(create: create);
  }

  @override
  void create(Ref ref) {
    final _$cb = _createCb ?? another;
    return _$cb(ref);
  }
}

String _$anotherHash() => r'1901cd6ee57ea427f82e6d5bbee79e91ddf71065';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
