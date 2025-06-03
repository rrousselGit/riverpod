// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'only_use_keep_alive_inside_keep_alive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(keepAlive)
const keepAliveProvider = KeepAliveProvider._();

final class KeepAliveProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const KeepAliveProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'keepAliveProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$keepAliveHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return keepAlive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$keepAliveHash() => r'095b2cb2261b9d79721aa6552b8aaf0d8a7bb7ee';

@ProviderFor(KeepAliveClass)
const keepAliveClassProvider = KeepAliveClassProvider._();

final class KeepAliveClassProvider
    extends $NotifierProvider<KeepAliveClass, int> {
  const KeepAliveClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'keepAliveClassProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$keepAliveClassHash();

  @$internal
  @override
  KeepAliveClass create() => KeepAliveClass();

  @$internal
  @override
  $NotifierProviderElement<KeepAliveClass, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$keepAliveClassHash() => r'e2fffa4d14837dfef71f6a2cc230b826b82541ea';

abstract class _$KeepAliveClass extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(autoDispose)
const autoDisposeProvider = AutoDisposeProvider._();

final class AutoDisposeProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const AutoDisposeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'autoDisposeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$autoDisposeHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return autoDispose(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$autoDisposeHash() => r'1ace7b4b2957ecf77b683b868e91a2614fc77d03';

@ProviderFor(AutoDisposeClass)
const autoDisposeClassProvider = AutoDisposeClassProvider._();

final class AutoDisposeClassProvider
    extends $NotifierProvider<AutoDisposeClass, int> {
  const AutoDisposeClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'autoDisposeClassProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$autoDisposeClassHash();

  @$internal
  @override
  AutoDisposeClass create() => AutoDisposeClass();

  @$internal
  @override
  $NotifierProviderElement<AutoDisposeClass, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$autoDisposeClassHash() => r'5127ab94f7ab4ccf90deb3fca90d7a3c3c4c83f5';

abstract class _$AutoDisposeClass extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(fn)
const fnProvider = FnProvider._();

final class FnProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const FnProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fnProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fnHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return fn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$fnHash() => r'e96b0302f7492f5aecedd46f6edeeea456839d01';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
