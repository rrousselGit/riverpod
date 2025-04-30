// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(other)
const otherProvider = OtherProvider._();

final class OtherProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const OtherProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'otherProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$otherHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return other(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$otherHash() => r'5d27b2b1b1c6bd17ba0844f74ade2088611be371';

@ProviderFor(Example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $NotifierProvider<Example, int> {
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
  $NotifierProviderElement<Example, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$exampleHash() => r'893db991b377b8e314e60c429043e5e81f1fd526';

abstract class _$Example extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
