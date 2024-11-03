// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'raw_usage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(rawStream)
const rawStreamProvider = RawStreamProvider._();

final class RawStreamProvider
    extends $FunctionalProvider<Raw<Stream<int>>, Raw<Stream<int>>>
    with $Provider<Raw<Stream<int>>> {
  const RawStreamProvider._(
      {Raw<Stream<int>> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'rawStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Stream<int>> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$rawStreamHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Stream<int>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Stream<int>>>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Raw<Stream<int>>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RawStreamProvider $copyWithCreate(
    Raw<Stream<int>> Function(
      Ref ref,
    ) create,
  ) {
    return RawStreamProvider._(create: create);
  }

  @override
  Raw<Stream<int>> create(Ref ref) {
    final _$cb = _createCb ?? rawStream;
    return _$cb(ref);
  }
}

String _$rawStreamHash() => r'9ce48e3afce64329958af139c77f5e271e0bf04f';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
