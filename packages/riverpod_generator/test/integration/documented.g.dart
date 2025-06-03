// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documented.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Hello world
// Foo
@ProviderFor(functional)
const functionalProvider = FunctionalProvider._();

/// Hello world
// Foo
final class FunctionalProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  /// Hello world
// Foo
  const FunctionalProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'functionalProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$functionalHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return functional(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$functionalHash() => r'52eddcd28b005800da9cf6c22df77f2f040bfb34';

/// Hello world
// Foo
@ProviderFor(ClassBased)
const classBasedProvider = ClassBasedProvider._();

/// Hello world
// Foo
final class ClassBasedProvider extends $NotifierProvider<ClassBased, String> {
  /// Hello world
// Foo
  const ClassBasedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'classBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classBasedHash();

  @$internal
  @override
  ClassBased create() => ClassBased();

  @$internal
  @override
  $NotifierProviderElement<ClassBased, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$classBasedHash() => r'f1139017b1fcf38017402b514c61fb32dae40c39';

abstract class _$ClassBased extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Hello world
// Foo
@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// Hello world
// Foo
final class FamilyProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Hello world
// Foo
  const FamilyProvider._(
      {required FamilyFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() {
    return r'familyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as int;
    return family(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$familyHash() => r'5164f4ea1f2d6c741e5c600c48a1b2ac2be7a1eb';

/// Hello world
// Foo
final class FamilyFamily extends $Family
    with $FunctionalFamilyOverride<String, int> {
  const FamilyFamily._()
      : super(
          retry: null,
          name: r'familyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Hello world
// Foo
  FamilyProvider call(
    int id,
  ) =>
      FamilyProvider._(argument: id, from: this);

  @override
  String toString() => r'familyProvider';
}

/// Hello world
// Foo
@ProviderFor(ClassFamilyBased)
const classFamilyBasedProvider = ClassFamilyBasedFamily._();

/// Hello world
// Foo
final class ClassFamilyBasedProvider
    extends $NotifierProvider<ClassFamilyBased, String> {
  /// Hello world
// Foo
  const ClassFamilyBasedProvider._(
      {required ClassFamilyBasedFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'classFamilyBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classFamilyBasedHash();

  @override
  String toString() {
    return r'classFamilyBasedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClassFamilyBased create() => ClassFamilyBased();

  @$internal
  @override
  $NotifierProviderElement<ClassFamilyBased, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClassFamilyBasedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classFamilyBasedHash() => r'8d83e9a88356796298419574f360e8bf95aa0729';

/// Hello world
// Foo
final class ClassFamilyBasedFamily extends $Family
    with $ClassFamilyOverride<ClassFamilyBased, String, String, String, int> {
  const ClassFamilyBasedFamily._()
      : super(
          retry: null,
          name: r'classFamilyBasedProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Hello world
// Foo
  ClassFamilyBasedProvider call(
    int id,
  ) =>
      ClassFamilyBasedProvider._(argument: id, from: this);

  @override
  String toString() => r'classFamilyBasedProvider';
}

abstract class _$ClassFamilyBased extends $Notifier<String> {
  late final _$args = ref.$arg as int;

  /// Hello world
// Foo
  int get id => _$args;

  String build(
    int id,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
