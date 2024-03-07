// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef StreamExampleRef = Ref<AsyncValue<int>>;

@ProviderFor(streamExample)
const streamExampleProvider = StreamExampleProvider._();

final class StreamExampleProvider
    extends $FunctionalProvider<AsyncValue<int>, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int, StreamExampleRef> {
  const StreamExampleProvider._(
      {Stream<int> Function(
        StreamExampleRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'streamExampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<int> Function(
    StreamExampleRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$streamExampleHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  StreamExampleProvider $copyWithCreate(
    Stream<int> Function(
      StreamExampleRef ref,
    ) create,
  ) {
    return StreamExampleProvider._(create: create);
  }

  @override
  Stream<int> create(StreamExampleRef ref) {
    final _$cb = _createCb ?? streamExample;
    return _$cb(ref);
  }
}

String _$streamExampleHash() => r'ca9993b22f6d587b20c041133cacd28d01933074';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
