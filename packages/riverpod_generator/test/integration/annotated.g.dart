// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(functional)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const functionalProvider = FunctionalFamily._();

final class FunctionalProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  const FunctionalProvider._(
      {required FunctionalFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'functionalProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$functionalHash();

  @override
  String toString() {
    return r'functionalProvider'
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
    return functional(
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
    return other is FunctionalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$functionalHash() => r'ba8606cd0526e2dde0f775eb8f4c9d8b5b6fdf2c';

final class FunctionalFamily extends $Family
    with $FunctionalFamilyOverride<String, int> {
  const FunctionalFamily._()
      : super(
          retry: null,
          name: r'functionalProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FunctionalProvider call(
    @Deprecated('field') int id,
  ) =>
      FunctionalProvider._(argument: id, from: this);

  @override
  String toString() => r'functionalProvider';
}

@ProviderFor(ClassBased)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const classBasedProvider = ClassBasedFamily._();

final class ClassBasedProvider extends $NotifierProvider<ClassBased, String> {
  const ClassBasedProvider._(
      {required ClassBasedFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'classBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classBasedHash();

  @override
  String toString() {
    return r'classBasedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClassBased create() => ClassBased();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClassBasedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classBasedHash() => r'92b444806ef8a304c6e0dc3d8e2383601e781183';

final class ClassBasedFamily extends $Family
    with $ClassFamilyOverride<ClassBased, String, String, String, int> {
  const ClassBasedFamily._()
      : super(
          retry: null,
          name: r'classBasedProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ClassBasedProvider call(
    @Deprecated('field') int id,
  ) =>
      ClassBasedProvider._(argument: id, from: this);

  @override
  String toString() => r'classBasedProvider';
}

abstract class _$ClassBased extends $Notifier<String> {
  late final _$args = ref.$arg as int;
  @Deprecated('field')
  int get id => _$args;

  String build(
    @Deprecated('field') int id,
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

@ProviderFor(family)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const familyProvider = FamilyFamily._();

final class FamilyProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
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

String _$familyHash() => r'14b97009aec20a0332208f8a60bc177b44c9d1d4';

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

  FamilyProvider call(
    int id,
  ) =>
      FamilyProvider._(argument: id, from: this);

  @override
  String toString() => r'familyProvider';
}

@ProviderFor(notCopiedFunctional)
const notCopiedFunctionalProvider = NotCopiedFunctionalProvider._();

final class NotCopiedFunctionalProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  const NotCopiedFunctionalProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notCopiedFunctionalProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notCopiedFunctionalHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return notCopiedFunctional(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$notCopiedFunctionalHash() =>
    r'7b2cd9abef57493eebc1c05b1d2b4e2743ddbea2';

@ProviderFor(NotCopiedClassBased)
const notCopiedClassBasedProvider = NotCopiedClassBasedProvider._();

final class NotCopiedClassBasedProvider
    extends $NotifierProvider<NotCopiedClassBased, String> {
  const NotCopiedClassBasedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notCopiedClassBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notCopiedClassBasedHash();

  @$internal
  @override
  NotCopiedClassBased create() => NotCopiedClassBased();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$notCopiedClassBasedHash() =>
    r'd2aefd08a78e3bb4c02000d4931a3bf15c01b495';

abstract class _$NotCopiedClassBased extends $Notifier<String> {
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

@ProviderFor(notCopiedFamily)
const notCopiedFamilyProvider = NotCopiedFamilyFamily._();

final class NotCopiedFamilyProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  const NotCopiedFamilyProvider._(
      {required NotCopiedFamilyFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'notCopiedFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notCopiedFamilyHash();

  @override
  String toString() {
    return r'notCopiedFamilyProvider'
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
    return notCopiedFamily(
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
    return other is NotCopiedFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notCopiedFamilyHash() => r'ea652776532e2bf993a249b25b5254fc3dfff4b9';

final class NotCopiedFamilyFamily extends $Family
    with $FunctionalFamilyOverride<String, int> {
  const NotCopiedFamilyFamily._()
      : super(
          retry: null,
          name: r'notCopiedFamilyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NotCopiedFamilyProvider call(
    int id,
  ) =>
      NotCopiedFamilyProvider._(argument: id, from: this);

  @override
  String toString() => r'notCopiedFamilyProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
