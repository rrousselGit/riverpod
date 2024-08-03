// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ExampleRef = Ref<AsyncValue<Object>>;

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider
    extends $FunctionalProvider<AsyncValue<Object>, FutureOr<Object>>
    with $FutureModifier<Object>, $FutureProvider<Object, ExampleRef> {
  const ExampleProvider._(
      {FutureOr<Object> Function(
        ExampleRef ref,
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

  final FutureOr<Object> Function(
    ExampleRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $FutureProviderElement<Object> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  ExampleProvider $copyWithCreate(
    FutureOr<Object> Function(
      ExampleRef ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  FutureOr<Object> create(ExampleRef ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'3ff29b1cd8fa864286a2a04e39adf1c8589b4275';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
