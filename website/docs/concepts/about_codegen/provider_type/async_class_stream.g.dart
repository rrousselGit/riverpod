// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_class_stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $StreamNotifierProvider<Example, String> {
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
  Example create() => Example();

  @$internal
  @override
  $StreamNotifierProviderElement<Example, String> $createElement(
          $ProviderPointer pointer) =>
      $StreamNotifierProviderElement(pointer);
}

String _$exampleHash() => r'4bca936132b77a9a804549f086f33571724b4804';

abstract class _$Example extends $StreamNotifier<String> {
  Stream<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String>, String>,
        AsyncValue<String>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
