// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_class_future.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $AsyncNotifierProvider<Example, String> {
  const ExampleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  Example create() => Example();

  @$internal
  @override
  $AsyncNotifierProviderElement<Example, String> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$exampleHash() => r'8a906741b8ea4b9b0d3f0b924779704b3e1773a1';

abstract class _$Example extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<String>>, AsyncValue<String>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
