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
const functionalProvider = FunctionalProvider._();

final class FunctionalProvider
    extends $FunctionalProvider<String, String, FunctionalRef>
    with $Provider<String, FunctionalRef> {
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
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
    final fn = _createCb ?? functional;
    return fn(ref);
  }
}

String _$functionalHash() => r'69e260b1de8ba28cbeb8e24d628933366cde6b8b';

typedef FamilyRef = Ref<String>;

@ProviderFor(family)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const familyProvider = FamilyFamily._();

final class FamilyProvider
    extends $FunctionalProvider<String, String, FamilyRef>
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
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
    final fn = _createCb ?? family;
    final int argument = this.argument as int;
    return fn(
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
            .createElement(container);
      },
    );
  }
}

typedef NotCopiedFunctionalRef = Ref<String>;

@ProviderFor(notCopiedFunctional)
const notCopiedFunctionalProvider = NotCopiedFunctionalProvider._();

final class NotCopiedFunctionalProvider
    extends $FunctionalProvider<String, String, NotCopiedFunctionalRef>
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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
    final fn = _createCb ?? notCopiedFunctional;
    return fn(ref);
  }
}

String _$notCopiedFunctionalHash() =>
    r'30587ee9ceb75d5c8562015ad4a67ec0b107c1f6';

typedef NotCopiedFamilyRef = Ref<String>;

@ProviderFor(notCopiedFamily)
const notCopiedFamilyProvider = NotCopiedFamilyFamily._();

final class NotCopiedFamilyProvider
    extends $FunctionalProvider<String, String, NotCopiedFamilyRef>
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

  @override
  $ProviderElement<String> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

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
    final fn = _createCb ?? notCopiedFamily;
    final int argument = this.argument as int;
    return fn(
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

  Override overrideWith(
    String Function(
      NotCopiedFamilyRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as NotCopiedFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .createElement(container);
      },
    );
  }
}

@ProviderFor(ClassBased)
@Deprecated('Deprecation message')
@visibleForTesting
@protected
const classBasedProvider = ClassBasedProvider._();

final class ClassBasedProvider extends $NotifierProvider<ClassBased, String> {
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
  $NotifierProviderElement<ClassBased, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$classBasedHash() => r'f40d1a032ee264aafd7686a985cdf1937f2dc108';

abstract class _$ClassBased extends $Notifier<String> {
  String build();

  @$internal
  @override
  String runBuild() => build();
}

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
  $NotifierProviderElement<NotCopiedClassBased, String> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$notCopiedClassBasedHash() =>
    r'd2aefd08a78e3bb4c02000d4931a3bf15c01b495';

abstract class _$NotCopiedClassBased extends $Notifier<String> {
  String build();

  @$internal
  @override
  String runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
