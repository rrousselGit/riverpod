// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider
    extends $FunctionalProvider<AsyncValue<Object>, Object, FutureOr<Object>>
    with $FutureModifier<Object>, $FutureProvider<Object> {
  const ExampleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $FutureProviderElement<Object> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Object> create(Ref ref) {
    return example(ref);
  }
}

String _$exampleHash() => r'7721b15eade2919325624bb7c4fd0bfb0cfc3e68';
