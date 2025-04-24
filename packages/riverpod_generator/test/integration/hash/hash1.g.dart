// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash1.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(simple)
const simpleProvider = SimpleProvider._();

final class SimpleProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const SimpleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simpleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return simple(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$simpleHash() => r'f916b37e39d654e9acfc9c2bd7a244902197b306';

@ProviderFor(simple2)
const simple2Provider = Simple2Provider._();

final class Simple2Provider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const Simple2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'simple2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simple2Hash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return simple2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$simple2Hash() => r'a60a8496fc391f5adf7ad45a12d0723f14f3127c';

@ProviderFor(SimpleClass)
const simpleClassProvider = SimpleClassProvider._();

final class SimpleClassProvider extends $NotifierProvider<SimpleClass, String> {
  const SimpleClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'simpleClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simpleClassHash();

  @$internal
  @override
  SimpleClass create() => SimpleClass();

  @$internal
  @override
  $NotifierProviderElement<SimpleClass, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$simpleClassHash() => r'958123cd6179c5b88da040cfeb71eb3061765277';

abstract class _$SimpleClass extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
