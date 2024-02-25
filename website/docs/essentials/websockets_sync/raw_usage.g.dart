// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'raw_usage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef RawStreamRef = Ref<Raw<Stream<int>>>;

@ProviderFor(rawStream)
const rawStreamProvider = RawStreamProvider._();

final class RawStreamProvider extends $FunctionalProvider<
    Raw<Stream<int>>,
    Raw<Stream<int>>,
    RawStreamRef> with $Provider<Raw<Stream<int>>, RawStreamRef> {
  const RawStreamProvider._(
      {Raw<Stream<int>> Function(
        RawStreamRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'rawStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Raw<Stream<int>> Function(
    RawStreamRef ref,
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
  $ProviderElement<Raw<Stream<int>>> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RawStreamProvider $copyWithCreate(
    Raw<Stream<int>> Function(
      RawStreamRef ref,
    ) create,
  ) {
    return RawStreamProvider._(create: create);
  }

  @override
  Raw<Stream<int>> create(RawStreamRef ref) {
    final _$cb = _createCb ?? rawStream;
    return _$cb(ref);
  }
}

String _$rawStreamHash() => r'7e7c2e8f4f08d33a4d86d60449e143c419ca4822';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
