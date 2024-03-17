// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotated.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FunctionalRef = Ref<String>;

@ProviderFor(functional)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const functionalProvider = FunctionalFamily._();

final class FunctionalProvider extends $FunctionalProvider<String, String>
    with $Provider<String, FunctionalRef> {
  const FunctionalProvider._(
      {required FunctionalFamily super.from,
      required int super.argument,
      String Function(
        FunctionalRef ref,
        @Deprecated('field') int id,
      )? create})
      : _createCb = create,
        super(
          name: r'functionalProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    FunctionalRef ref,
    @Deprecated('field') int id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$functionalHash();

  @override
  String toString() {
    return r'functionalProvider'
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
  FunctionalProvider $copyWithCreate(
    String Function(
      FunctionalRef ref,
    ) create,
  ) {
    return FunctionalProvider._(
        argument: argument as int,
        from: from! as FunctionalFamily,
        create: (
          ref,
          @Deprecated('field') int id,
        ) =>
            create(ref));
  }

  @override
  String create(FunctionalRef ref) {
    final _$cb = _createCb ?? functional;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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

String _$functionalHash() => r'288107f94c896141a9b3999f606e4ccdf078f15e';

final class FunctionalFamily extends Family {
  const FunctionalFamily._()
      : super(
          name: r'functionalProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FunctionalProvider call(
    @Deprecated('field') int id,
  ) =>
      FunctionalProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$functionalHash();

  @override
  String toString() => r'functionalProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      FunctionalRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FunctionalProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

@ProviderFor(ClassBased)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const classBasedProvider = ClassBasedFamily._();

final class ClassBasedProvider extends $NotifierProvider<ClassBased, String> {
  const ClassBasedProvider._(
      {required ClassBasedFamily super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      ClassBased Function()? create})
      : _createCb = create,
        super(
          name: r'classBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ClassBased Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$classBasedHash();

  @override
  String toString() {
    return r'classBasedProvider'
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
  ClassBased create() => _createCb?.call() ?? ClassBased();

  @$internal
  @override
  ClassBasedProvider $copyWithCreate(
    ClassBased Function() create,
  ) {
    return ClassBasedProvider._(
        argument: argument as int,
        from: from! as ClassBasedFamily,
        create: create);
  }

  @$internal
  @override
  ClassBasedProvider $copyWithBuild(
    String Function(
      Ref<String>,
      ClassBased,
    ) build,
  ) {
    return ClassBasedProvider._(
        argument: argument as int,
        from: from! as ClassBasedFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ClassBased, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

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

final class ClassBasedFamily extends Family {
  const ClassBasedFamily._()
      : super(
          name: r'classBasedProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ClassBasedProvider call(
    @Deprecated('field') int id,
  ) =>
      ClassBasedProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$classBasedHash();

  @override
  String toString() => r'classBasedProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    ClassBased Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ClassBasedProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    String Function(Ref<String> ref, ClassBased notifier, int argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ClassBasedProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$ClassBased extends $Notifier<String> {
  late final _$args = ref.$arg as int;
  @Deprecated('field')
  int get id => _$args;

  String build(
    @Deprecated('field') int id,
  );
  @$internal
  @override
  String runBuild() => build(
        _$args,
      );
}

typedef FamilyRef = Ref<String>;

@ProviderFor(family)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const familyProvider = FamilyFamily._();

final class FamilyProvider extends $FunctionalProvider<String, String>
    with $Provider<String, FamilyRef> {
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

String _$familyHash() => r'd70685b83be840bfd9e79c11fb84c905d19d6e10';

final class FamilyFamily extends Family {
  const FamilyFamily._()
      : super(
          name: r'familyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

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

typedef NotCopiedFunctionalRef = Ref<String>;

@ProviderFor(notCopiedFunctional)
const notCopiedFunctionalProvider = NotCopiedFunctionalProvider._();

final class NotCopiedFunctionalProvider
    extends $FunctionalProvider<String, String>
    with $Provider<String, NotCopiedFunctionalRef> {
  const NotCopiedFunctionalProvider._(
      {String Function(
        NotCopiedFunctionalRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'notCopiedFunctionalProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    NotCopiedFunctionalRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notCopiedFunctionalHash();

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
  NotCopiedFunctionalProvider $copyWithCreate(
    String Function(
      NotCopiedFunctionalRef ref,
    ) create,
  ) {
    return NotCopiedFunctionalProvider._(create: create);
  }

  @override
  String create(NotCopiedFunctionalRef ref) {
    final _$cb = _createCb ?? notCopiedFunctional;
    return _$cb(ref);
  }
}

String _$notCopiedFunctionalHash() =>
    r'30587ee9ceb75d5c8562015ad4a67ec0b107c1f6';

@ProviderFor(NotCopiedClassBased)
const notCopiedClassBasedProvider = NotCopiedClassBasedProvider._();

final class NotCopiedClassBasedProvider
    extends $NotifierProvider<NotCopiedClassBased, String> {
  const NotCopiedClassBasedProvider._(
      {super.runNotifierBuildOverride, NotCopiedClassBased Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'notCopiedClassBasedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final NotCopiedClassBased Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notCopiedClassBasedHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  NotCopiedClassBased create() => _createCb?.call() ?? NotCopiedClassBased();

  @$internal
  @override
  NotCopiedClassBasedProvider $copyWithCreate(
    NotCopiedClassBased Function() create,
  ) {
    return NotCopiedClassBasedProvider._(create: create);
  }

  @$internal
  @override
  NotCopiedClassBasedProvider $copyWithBuild(
    String Function(
      Ref<String>,
      NotCopiedClassBased,
    ) build,
  ) {
    return NotCopiedClassBasedProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NotCopiedClassBased, String> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$notCopiedClassBasedHash() =>
    r'd2aefd08a78e3bb4c02000d4931a3bf15c01b495';

abstract class _$NotCopiedClassBased extends $Notifier<String> {
  String build();
  @$internal
  @override
  String runBuild() => build();
}

typedef NotCopiedFamilyRef = Ref<String>;

@ProviderFor(notCopiedFamily)
const notCopiedFamilyProvider = NotCopiedFamilyFamily._();

final class NotCopiedFamilyProvider extends $FunctionalProvider<String, String>
    with $Provider<String, NotCopiedFamilyRef> {
  const NotCopiedFamilyProvider._(
      {required NotCopiedFamilyFamily super.from,
      required int super.argument,
      String Function(
        NotCopiedFamilyRef ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          name: r'notCopiedFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    NotCopiedFamilyRef ref,
    int id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$notCopiedFamilyHash();

  @override
  String toString() {
    return r'notCopiedFamilyProvider'
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
  NotCopiedFamilyProvider $copyWithCreate(
    String Function(
      NotCopiedFamilyRef ref,
    ) create,
  ) {
    return NotCopiedFamilyProvider._(
        argument: argument as int,
        from: from! as NotCopiedFamilyFamily,
        create: (
          ref,
          int id,
        ) =>
            create(ref));
  }

  @override
  String create(NotCopiedFamilyRef ref) {
    final _$cb = _createCb ?? notCopiedFamily;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
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

String _$notCopiedFamilyHash() => r'6ef06ce6ebd73b476870bbe1af41c4f3fbe8ddb1';

final class NotCopiedFamilyFamily extends Family {
  const NotCopiedFamilyFamily._()
      : super(
          name: r'notCopiedFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NotCopiedFamilyProvider call(
    int id,
  ) =>
      NotCopiedFamilyProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$notCopiedFamilyHash();

  @override
  String toString() => r'notCopiedFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      NotCopiedFamilyRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as NotCopiedFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
