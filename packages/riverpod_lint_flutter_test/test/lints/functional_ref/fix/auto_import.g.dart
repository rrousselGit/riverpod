// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_import.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const ExampleProvider._(
      {int Function(
        Ref ref,
      )? create})
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

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  ExampleProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'638d7db2be22eaad0f51ea0b3ae38e0483d43725';

@ProviderFor(empty)
const emptyProvider = EmptyProvider._();

final class EmptyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const EmptyProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'emptyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$emptyHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  EmptyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return EmptyProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? empty;
    return _$cb(ref);
  }
}

String _$emptyHash() => r'eaec2981c894019fafd068e09478ffe961a8d188';

@ProviderFor(untyped)
const untypedProvider = UntypedProvider._();

final class UntypedProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const UntypedProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'untypedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$untypedHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  UntypedProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return UntypedProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? untyped;
    return _$cb(ref);
  }
}

String _$untypedHash() => r'5dd4815f63ed35a15a2e027b4e0cb496693f07f4';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
