// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_fn_stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider
    extends $FunctionalProvider<AsyncValue<String>, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  const ExampleProvider._(
      {Stream<String> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<String> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

  @override
  ExampleProvider $copyWithCreate(
    Stream<String> Function(
      Ref ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  Stream<String> create(Ref ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'f7f90ac5fbf939c0259a549b8e01a559b0d95ff1';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
