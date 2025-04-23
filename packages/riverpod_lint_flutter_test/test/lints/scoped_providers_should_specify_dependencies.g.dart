// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoped_providers_should_specify_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(UnimplementedScoped)
const unimplementedScopedProvider = UnimplementedScopedProvider._();

final class UnimplementedScopedProvider
    extends $NotifierProvider<UnimplementedScoped, int> {
  const UnimplementedScopedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'unimplementedScopedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  @override
  String debugGetCreateSourceHash() => _$unimplementedScopedHash();

  @$internal
  @override
  UnimplementedScoped create() => UnimplementedScoped();

  @$internal
  @override
  $NotifierProviderElement<UnimplementedScoped, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$unimplementedScopedHash() =>
    r'0511a23bd69f21f42fa4f20a9078f6a200a073cb';

abstract class _$UnimplementedScoped extends $Notifier<int> {
  int build() => throw MissingScopeException(ref);
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(scoped)
const scopedProvider = ScopedProvider._();

final class ScopedProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const ScopedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scopedProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  @override
  String debugGetCreateSourceHash() => _$scopedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return scoped(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$scopedHash() => r'5a271e9b23e18517694454448b922a6c9d03781e';

@ProviderFor(root)
const rootProvider = RootProvider._();

final class RootProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const RootProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'rootProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$rootHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return root(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$rootHash() => r'dda8bbb46cb4d7c658597669e3be92e2447dcfb0';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
