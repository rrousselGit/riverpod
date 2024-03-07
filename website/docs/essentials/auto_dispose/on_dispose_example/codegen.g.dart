// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef OtherRef = Ref<int>;

@ProviderFor(other)
const otherProvider = OtherProvider._();

final class OtherProvider extends $FunctionalProvider<int, int>
    with $Provider<int, OtherRef> {
  const OtherProvider._(
      {int Function(
        OtherRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'otherProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    OtherRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$otherHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  OtherProvider $copyWithCreate(
    int Function(
      OtherRef ref,
    ) create,
  ) {
    return OtherProvider._(create: create);
  }

  @override
  int create(OtherRef ref) {
    final _$cb = _createCb ?? other;
    return _$cb(ref);
  }
}

String _$otherHash() => r'b23696171643dfbab23d167ed9b5ab0639e6a86c';

typedef ExampleRef = Ref<AsyncValue<int>>;

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider
    extends $FunctionalProvider<AsyncValue<int>, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int, ExampleRef> {
  const ExampleProvider._(
      {Stream<int> Function(
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

  final Stream<int> Function(
    ExampleRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  ExampleProvider $copyWithCreate(
    Stream<int> Function(
      ExampleRef ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  Stream<int> create(ExampleRef ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'29f92958e0d0e3f13ac033e92cd2e4072339c7db';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
