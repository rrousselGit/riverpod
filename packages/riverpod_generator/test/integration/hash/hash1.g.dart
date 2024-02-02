// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash1.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef SimpleRef = Ref<String>;

const simpleProvider = SimpleProvider._();

final class SimpleProvider
    extends $FunctionalProvider<String, String, SimpleRef> {
  const SimpleProvider._({
    String Function(
      SimpleRef ref,
    )? create,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$simpleHash,
          name: r'simple',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          from: null,
          argument: null,
        );

  final String Function(
    SimpleRef ref,
  )? _createCb;

  @override
  String create(SimpleRef ref) {
    final fn = _createCb ?? simple;

    return fn(
      ref,
    );
  }

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  SimpleProvider copyWithCreate(
    String Function(
      SimpleRef ref,
    ) create,
  ) {
    return SimpleProvider._(
      create: create,
    );
  }
}

String _$simpleHash() => r'ff9f7451526aef5b3af6646814631a502ad76a5f';
typedef Simple2Ref = Ref<String>;

const simple2Provider = Simple2Provider._();

final class Simple2Provider
    extends $FunctionalProvider<String, String, Simple2Ref> {
  const Simple2Provider._({
    String Function(
      Simple2Ref ref,
    )? create,
  })  : _createCb = create,
        super(
          debugGetCreateSourceHash: _$simple2Hash,
          name: r'simple2',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
          from: null,
          argument: null,
        );

  final String Function(
    Simple2Ref ref,
  )? _createCb;

  @override
  String create(Simple2Ref ref) {
    final fn = _createCb ?? simple2;

    return fn(
      ref,
    );
  }

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  Simple2Provider copyWithCreate(
    String Function(
      Simple2Ref ref,
    ) create,
  ) {
    return Simple2Provider._(
      create: create,
    );
  }
}

String _$simple2Hash() => r'06327442776394c5c9cbb33b048d7a42e709e7fd';
String _$simpleClassHash() => r'958123cd6179c5b88da040cfeb71eb3061765277';
const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
