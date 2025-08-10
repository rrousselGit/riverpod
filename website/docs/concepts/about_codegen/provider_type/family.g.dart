// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(example)
const exampleProvider = ExampleFamily._();

final class ExampleProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const ExampleProvider._(
      {required ExampleFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @override
  String toString() {
    return r'exampleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as int;
    return example(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleHash() => r'7cd87bca029ed938b0e314a14fdfaa2875bd3079';

final class ExampleFamily extends $Family
    with $FunctionalFamilyOverride<String, int> {
  const ExampleFamily._()
      : super(
          retry: null,
          name: r'exampleProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ExampleProvider call(
    int param,
  ) =>
      ExampleProvider._(argument: param, from: this);

  @override
  String toString() => r'exampleProvider';
}
