// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scopes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(ScopedClass)
const scopedClassProvider = ScopedClassProvider._();

final class ScopedClassProvider extends $NotifierProvider<ScopedClass, int> {
  const ScopedClassProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scopedClassProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          $allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  @override
  String debugGetCreateSourceHash() => _$scopedClassHash();

  @$internal
  @override
  ScopedClass create() => ScopedClass();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$scopedClassHash() => r'113acc46a2e61abfeb61cf4b89a1dc555e915793';

abstract class _$ScopedClass extends $Notifier<int> {
  int build() => throw MissingScopeException(ref);
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

@ProviderFor(ScopedClassFamily)
const scopedClassFamilyProvider = ScopedClassFamilyFamily._();

final class ScopedClassFamilyProvider
    extends $NotifierProvider<ScopedClassFamily, int> {
  const ScopedClassFamilyProvider._(
      {required ScopedClassFamilyFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'scopedClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scopedClassFamilyHash();

  @override
  String toString() {
    return r'scopedClassFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ScopedClassFamily create() => ScopedClassFamily();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScopedClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scopedClassFamilyHash() => r'04aeb0bbfdc363e2c8714c7a5967368a7f990d58';

final class ScopedClassFamilyFamily extends $Family
    with $ClassFamilyOverride<ScopedClassFamily, int, int, int, int> {
  const ScopedClassFamilyFamily._()
      : super(
          retry: null,
          name: r'scopedClassFamilyProvider',
          dependencies: const <ProviderOrFamily>[],
          $allTransitiveDependencies: const <ProviderOrFamily>[],
          isAutoDispose: true,
        );

  ScopedClassFamilyProvider call(
    int a,
  ) =>
      ScopedClassFamilyProvider._(argument: a, from: this);

  @override
  String toString() => r'scopedClassFamilyProvider';
}

abstract class _$ScopedClassFamily extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get a => _$args;

  int build(
    int a,
  ) =>
      throw MissingScopeException(ref);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
