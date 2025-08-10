// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'old_lifecycles_final.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(duration)
const durationProvider = DurationProvider._();

final class DurationProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  const DurationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'durationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$durationHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return duration(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$durationHash() => r'997cacfb78da8107053428dfc5515497354b50c6';

@ProviderFor(repository)
const repositoryProvider = RepositoryProvider._();

final class RepositoryProvider
    extends $FunctionalProvider<_MyRepo, _MyRepo, _MyRepo>
    with $Provider<_MyRepo> {
  const RepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'repositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$repositoryHash();

  @$internal
  @override
  $ProviderElement<_MyRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  _MyRepo create(Ref ref) {
    return repository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_MyRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<_MyRepo>(value),
    );
  }
}

String _$repositoryHash() => r'8c1b035ba722660550674e92444db7b6f25ac2a3';

@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierProvider._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  const MyNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  @$internal
  @override
  MyNotifier create() => MyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$myNotifierHash() => r'8ea2586ea29d12306efd4b8b847142136dd20338';

abstract class _$MyNotifier extends $Notifier<int> {
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
