// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash1.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(simple)
final simpleProvider = SimpleProvider._();

final class SimpleProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  SimpleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'simpleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
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
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$simpleHash() => r'f916b37e39d654e9acfc9c2bd7a244902197b306';

@ProviderFor(simple2)
final simple2Provider = Simple2Provider._();

final class Simple2Provider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  Simple2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'simple2Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
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
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$simple2Hash() => r'a60a8496fc391f5adf7ad45a12d0723f14f3127c';

@ProviderFor(SimpleClass)
final simpleClassProvider = SimpleClassProvider._();

final class SimpleClassProvider extends $NotifierProvider<SimpleClass, String> {
  SimpleClassProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'simpleClassProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$simpleClassHash();

  @$internal
  @override
  SimpleClass create() => SimpleClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
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
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
