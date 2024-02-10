// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ExampleRef = Ref<Object?>;

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider
    extends $FunctionalProvider<Object?, Object?, ExampleRef>
    with $Provider<Object?, ExampleRef> {
  const ExampleProvider._(
      {Object? Function(
        ExampleRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Object? Function(
    ExampleRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Object?>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Object?> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ExampleProvider $copyWithCreate(
    Object? Function(
      ExampleRef ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  Object? create(ExampleRef ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'1fccbdbec0e3585bc9d3a5709ac88a8919dd78fa';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
