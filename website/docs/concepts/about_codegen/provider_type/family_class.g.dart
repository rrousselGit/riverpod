// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_class.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Example)
const exampleProvider = ExampleFamily._();

final class ExampleProvider extends $NotifierProvider<Example, String> {
  const ExampleProvider._(
      {required ExampleFamily super.from,
      required (
        int, {
        String param2,
      })
          super.argument})
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
        '$argument';
  }

  @$internal
  @override
  Example create() => Example();

  @$internal
  @override
  $NotifierProviderElement<Example, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
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

String _$exampleHash() => r'8025d93d6f5e9286043b1ce7ae55bead44f30acc';

final class ExampleFamily extends $Family
    with
        $ClassFamilyOverride<
            Example,
            String,
            String,
            String,
            (
              int, {
              String param2,
            })> {
  const ExampleFamily._()
      : super(
          retry: null,
          name: r'exampleProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ExampleProvider call(
    int param1, {
    String param2 = 'foo',
  }) =>
      ExampleProvider._(argument: (
        param1,
        param2: param2,
      ), from: this);

  @override
  String toString() => r'exampleProvider';
}

abstract class _$Example extends $Notifier<String> {
  late final _$args = ref.$arg as (
    int, {
    String param2,
  });
  int get param1 => _$args.$1;
  String get param2 => _$args.param2;

  String build(
    int param1, {
    String param2 = 'foo',
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      param2: _$args.param2,
    );
    final ref = this.ref as $Ref<String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
