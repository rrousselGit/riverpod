// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(streamExample)
const streamExampleProvider = StreamExampleProvider._();

final class StreamExampleProvider
    extends $FunctionalProvider<AsyncValue<int>, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  const StreamExampleProvider._(
      {Stream<int> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'streamExampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<int> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$streamExampleHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

  @override
  StreamExampleProvider $copyWithCreate(
    Stream<int> Function(
      Ref ref,
    ) create,
  ) {
    return StreamExampleProvider._(create: create);
  }

  @override
  Stream<int> create(Ref ref) {
    final _$cb = _createCb ?? streamExample;
    return _$cb(ref);
  }
}

String _$streamExampleHash() => r'5f0e824562e820b85cc0d031a7fcce1d381023a5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
