// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash1.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef SimpleRef = Ref<String>;

@ProviderFor(simple)
const simpleProvider = SimpleProvider._();

final class SimpleProvider
    extends $FunctionalProvider<String, String, SimpleRef>
    with $Provider<String, SimpleRef> {
  const SimpleProvider._(
      {String Function(
        SimpleRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'simpleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    SimpleRef ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  SimpleProvider $copyWithCreate(
    String Function(
      SimpleRef ref,
    ) create,
  ) {
    return SimpleProvider._(create: create);
  }

  @override
  String create(SimpleRef ref) {
    final _$cb = _createCb ?? simple;
    return _$cb(ref);
  }
}

String _$simpleHash() => r'ff9f7451526aef5b3af6646814631a502ad76a5f';

typedef Simple2Ref = Ref<String>;

@ProviderFor(simple2)
const simple2Provider = Simple2Provider._();

final class Simple2Provider
    extends $FunctionalProvider<String, String, Simple2Ref>
    with $Provider<String, Simple2Ref> {
  const Simple2Provider._(
      {String Function(
        Simple2Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'simple2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Simple2Ref ref,
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Simple2Provider $copyWithCreate(
    String Function(
      Simple2Ref ref,
    ) create,
  ) {
    return Simple2Provider._(create: create);
  }

  @override
  String create(Simple2Ref ref) {
    final _$cb = _createCb ?? simple2;
    return _$cb(ref);
  }
}

String _$simple2Hash() => r'06327442776394c5c9cbb33b048d7a42e709e7fd';

@ProviderFor(SimpleClass)
const simpleClassProvider = SimpleClassProvider._();

final class SimpleClassProvider extends $NotifierProvider<SimpleClass, String> {
  const SimpleClassProvider._(
      {super.runNotifierBuildOverride, SimpleClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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
      Ref<String>,
      SimpleClass,
    ) build,
  ) {
    return SimpleClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<SimpleClass, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$simpleClassHash() => r'958123cd6179c5b88da040cfeb71eb3061765277';

abstract class _$SimpleClass extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
