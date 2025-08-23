// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documented.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hello world
// Foo

@ProviderFor(functional)
@annotation
const functionalProvider = FunctionalProvider._();

/// Hello world
// Foo

@annotation
final class FunctionalProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
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

String _$functionalHash() => r'483ddb9ce91e80912574bc3f64456eea5b6c7b0e';

/// Hello world
// Foo

@ProviderFor(ClassBased)
@annotation
const classBasedProvider = ClassBasedProvider._();

/// Hello world
// Foo
@annotation
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$classBasedHash() => r'5c45e9bfdae87633f8cadb30533b946f8d0c9e2b';

/// Hello world
// Foo

@annotation
abstract class _$ClassBased extends $Notifier<String> {
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

/// Hello world
// Foo

@ProviderFor(family)
@annotation
const familyProvider = FamilyFamily._();

/// Hello world
// Foo

@annotation
final class FamilyProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Hello world
  // Foo
  const FamilyProvider._({
    required FamilyFamily super.from,
    required int super.argument,
  }) : super(
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
    return family(ref, argument);
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

String _$familyHash() => r'13354dca1ecbd172ae0627e9ba644d52cd9cfaaf';

/// Hello world
// Foo

@annotation
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

  @annotation
  FamilyProvider call(int id) => FamilyProvider._(argument: id, from: this);

  @override
  String toString() => r'familyProvider';
}

/// Hello world
// Foo

@ProviderFor(ClassFamilyBased)
@annotation
const classFamilyBasedProvider = ClassFamilyBasedFamily._();

/// Hello world
// Foo
@annotation
final class ClassFamilyBasedProvider
    extends $NotifierProvider<ClassFamilyBased, String> {
  /// Hello world
  // Foo
  const ClassFamilyBasedProvider._({
    required ClassFamilyBasedFamily super.from,
    required int super.argument,
  }) : super(
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

String _$classFamilyBasedHash() => r'4681ad76c671518ac72ca40fa532126bc041dc2f';

/// Hello world
// Foo

@annotation
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

  @annotation
  ClassFamilyBasedProvider call(@annotation int id) =>
      ClassFamilyBasedProvider._(argument: id, from: this);

  @override
  String toString() => r'classFamilyBasedProvider';
}

/// Hello world
// Foo

@annotation
abstract class _$ClassFamilyBased extends $Notifier<String> {
  late final _$args = ref.$arg as int;

  /// Hello world
  // Foo
  @annotation
  int get id => _$args;

  String build(@annotation int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
