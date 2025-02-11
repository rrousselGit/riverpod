// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'sync_class.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $NotifierProvider<Example, String> {
  const ExampleProvider._(
      {super.runNotifierBuildOverride, Example Function()? create})
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

  final Example Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  Example create() => _createCb?.call() ?? Example();

  @$internal
  @override
  ExampleProvider $copyWithCreate(
    Example Function() create,
  ) {
    return ExampleProvider._(create: create);
  }

  @$internal
  @override
  ExampleProvider $copyWithBuild(
    String Function(
      Ref,
      Example,
    ) build,
  ) {
    return ExampleProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Example, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$exampleHash() => r'c237193ab6d57674973aaa02eb73db6f6822eb26';

abstract class _$Example extends $Notifier<String> {
  String build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element as $ClassProviderElement<NotifierBase<String>,
        String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
