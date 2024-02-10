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
final class FunctionalProvider
    extends $FunctionalProvider<String, String, FunctionalRef>
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
  $ProviderElement<String> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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

String _$functionalHash() => r'1198a9a7842513019f6a8cd1b32e72217a00ee8f';

/// Hello world
// Foo
typedef FamilyRef = Ref<String>;

/// Hello world
// Foo
@ProviderFor(family)
const familyProvider = FamilyFamily._();

/// Hello world
// Foo
final class FamilyProvider
    extends $FunctionalProvider<String, String, FamilyRef>
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
  $ProviderElement<String> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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

String _$familyHash() => r'339f0a8e0733a30bbb2220ce7ff6b9de7abe6022';

/// Hello world
// Foo
final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
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
      createElement: (container, provider) {
        provider as FamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

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
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
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
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

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
      createElement: (container, provider) {
        provider as ClassFamilyBasedProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
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
      createElement: (container, provider) {
        provider as ClassFamilyBasedProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$ClassFamilyBased extends $Notifier<String> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as int;

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

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
