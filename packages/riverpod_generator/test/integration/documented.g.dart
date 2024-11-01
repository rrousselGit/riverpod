// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documented.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Hello world
// Foo
typedef FunctionalRef = Ref<String>;

/// Hello world
// Foo
@ProviderFor(functional)
const functionalProvider = FunctionalProvider._();

/// Hello world
// Foo
final class FunctionalProvider extends $FunctionalProvider<String, String>
    with $Provider<String, FunctionalRef> {
  /// Hello world
// Foo
  const FunctionalProvider._(
      {String Function(
        FunctionalRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'functionalProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    FunctionalRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$functionalHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FunctionalProvider $copyWithCreate(
    String Function(
      FunctionalRef ref,
    ) create,
  ) {
    return FunctionalProvider._(create: create);
  }

  @override
  String create(FunctionalRef ref) {
    final _$cb = _createCb ?? functional;
    return _$cb(ref);
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
  const ClassBasedProvider._(
      {super.runNotifierBuildOverride, ClassBased Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'classBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ClassBased Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$classBasedHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  ClassBased create() => _createCb?.call() ?? ClassBased();

  @$internal
  @override
  ClassBasedProvider $copyWithCreate(
    ClassBased Function() create,
  ) {
    return ClassBasedProvider._(create: create);
  }

  @$internal
  @override
  ClassBasedProvider $copyWithBuild(
    String Function(
      Ref<String>,
      ClassBased,
    ) build,
  ) {
    return ClassBasedProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ClassBased, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$classBasedHash() => r'f1139017b1fcf38017402b514c61fb32dae40c39';

abstract class _$ClassBased extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

/// Hello world
// Foo
typedef FamilyRef = Ref<String>;

/// Hello world
// Foo
@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// Hello world
// Foo
final class FamilyProvider extends $FunctionalProvider<String, String>
    with $Provider<String, FamilyRef> {
  /// Hello world
// Foo
  const FamilyProvider._(
      {required FamilyFamily super.from,
      required int super.argument,
      String Function(
        FamilyRef ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'familyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    FamilyRef ref,
    int id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() {
    return r'familyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FamilyProvider $copyWithCreate(
    String Function(
      FamilyRef ref,
    ) create,
  ) {
    return FamilyProvider._(
        argument: argument as int,
        from: from! as FamilyFamily,
        create: (
          ref,
          int id,
        ) =>
            create(ref));
  }

  @override
  String create(FamilyRef ref) {
    final _$cb = _createCb ?? family;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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
final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
          retry: null,
          name: r'familyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Hello world
// Foo
  FamilyProvider call(
    int id,
  ) =>
      FamilyProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$familyHash();

  @override
  String toString() => r'familyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      FamilyRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
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
      {required ClassFamilyBasedFamily super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      ClassFamilyBased Function()? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'classFamilyBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ClassFamilyBased Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$classFamilyBasedHash();

  @override
  String toString() {
    return r'classFamilyBasedProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  ClassFamilyBased create() => _createCb?.call() ?? ClassFamilyBased();

  @$internal
  @override
  ClassFamilyBasedProvider $copyWithCreate(
    ClassFamilyBased Function() create,
  ) {
    return ClassFamilyBasedProvider._(
        argument: argument as int,
        from: from! as ClassFamilyBasedFamily,
        create: create);
  }

  @$internal
  @override
  ClassFamilyBasedProvider $copyWithBuild(
    String Function(
      Ref<String>,
      ClassFamilyBased,
    ) build,
  ) {
    return ClassFamilyBasedProvider._(
        argument: argument as int,
        from: from! as ClassFamilyBasedFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ClassFamilyBased, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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
final class ClassFamilyBasedFamily extends Family {
  const ClassFamilyBasedFamily._()
      : super(
          retry: null,
          name: r'classFamilyBasedProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Hello world
// Foo
  ClassFamilyBasedProvider call(
    int id,
  ) =>
      ClassFamilyBasedProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$classFamilyBasedHash();

  @override
  String toString() => r'classFamilyBasedProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    ClassFamilyBased Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ClassFamilyBasedProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function(Ref<String> ref, ClassFamilyBased notifier, int argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ClassFamilyBasedProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$ClassFamilyBased extends $Notifier<String> {
  late final _$args = ref.$arg as int;

  /// Hello world
// Foo
  int get id => _$args;

  String build(
    int id,
  );
  @$internal
  @override
  String runBuild() => build(
        _$args,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
