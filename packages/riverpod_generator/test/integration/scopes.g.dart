// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scopes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  @override
  String debugGetCreateSourceHash() => _$scopedClassHash();

  @$internal
  @override
  ScopedClass create() => ScopedClass();

  @$internal
  @override
  $NotifierProviderElement<ScopedClass, int> $createElement(
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

String _$scopedClassHash() => r'113acc46a2e61abfeb61cf4b89a1dc555e915793';

abstract class _$ScopedClass extends $Notifier<int> {
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
          allTransitiveDependencies: null,
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

  @$internal
  @override
  $NotifierProviderElement<ScopedClassFamily, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
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

final class ScopedClassFamilyFamily extends Family {
  const ScopedClassFamilyFamily._()
      : super(
          retry: null,
          name: r'scopedClassFamilyProvider',
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
          isAutoDispose: true,
        );

  ScopedClassFamilyProvider call(
    int a,
  ) =>
      ScopedClassFamilyProvider._(argument: a, from: this);

  @override
  String toString() => r'scopedClassFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          ScopedClassFamily Function(
            int args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as ScopedClassFamilyProvider;
            final argument = provider.argument as int;
            return provider
                .$view(create: () => create(argument))
                .$createElement(pointer);
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          int Function(Ref ref, ScopedClassFamily notifier, int argument)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as ScopedClassFamilyProvider;
            final argument = provider.argument as int;
            return provider
                .$view(
                    runNotifierBuildOverride: (ref, notifier) =>
                        build(ref, notifier, argument))
                .$createElement(pointer);
          });
}

abstract class _$ScopedClassFamily extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get a => _$args;

  int build(
    int a,
  ) =>
      throw MissingScopeException(ref);
  @$internal
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
