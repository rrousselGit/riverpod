// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'async_class_stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $StreamNotifierProvider<Example, String> {
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
    Stream<String> Function(
      Ref<AsyncValue<String>>,
      Example,
    ) build,
  ) {
    return ExampleProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $StreamNotifierProviderElement<Example, String> $createElement(
          $ProviderPointer pointer) =>
      $StreamNotifierProviderElement(this, pointer);
}

String _$exampleHash() => r'4bca936132b77a9a804549f086f33571724b4804';

abstract class _$Example extends $StreamNotifier<String> {
  Stream<String> build();
  @$internal
  @override
  Stream<String> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
