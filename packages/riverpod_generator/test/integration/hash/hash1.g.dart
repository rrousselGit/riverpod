// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash1.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(simple)
const simpleProvider = SimpleProvider._();

final class SimpleProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const SimpleProvider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$simpleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  SimpleProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return SimpleProvider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? simple;
    return _$cb(ref);
  }
}

String _$simpleHash() => r'f916b37e39d654e9acfc9c2bd7a244902197b306';

@ProviderFor(simple2)
const simple2Provider = Simple2Provider._();

final class Simple2Provider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const Simple2Provider._(
      {String Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'simple2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$simple2Hash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  Simple2Provider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return Simple2Provider._(create: create);
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? simple2;
    return _$cb(ref);
  }
}

String _$simple2Hash() => r'a60a8496fc391f5adf7ad45a12d0723f14f3127c';

@ProviderFor(SimpleClass)
const simpleClassProvider = SimpleClassProvider._();

final class SimpleClassProvider extends $NotifierProvider<SimpleClass, String> {
  const SimpleClassProvider._(
      {super.runNotifierBuildOverride, SimpleClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final SimpleClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$simpleClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  SimpleClass create() => _createCb?.call() ?? SimpleClass();

  @$internal
  @override
  SimpleClassProvider $copyWithCreate(
    SimpleClass Function() create,
  ) {
    return SimpleClassProvider._(create: create);
  }

  @$internal
  @override
  SimpleClassProvider $copyWithBuild(
    String Function(
      Ref,
      SimpleClass,
    ) build,
  ) {
    return SimpleClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<SimpleClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$simpleClassHash() => r'958123cd6179c5b88da040cfeb71eb3061765277';

abstract class _$SimpleClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
