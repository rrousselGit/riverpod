part of '../framework.dart';

/// A typedef representing the constructor of any classical provider.
@internal
typedef FunctionalProviderFactory< //
        ProviderT,
        CreatedT,
        ArgT>
    = ProviderT Function(
  Create<CreatedT> create, {
  required String? name,
  required List<ProviderOrFamily>? dependencies,
  required List<ProviderOrFamily>? allTransitiveDependencies,
  required bool isAutoDispose,
  required Family from,
  required ArgT argument,
  required Retry? retry,
});

/// A typedef representing the constructor of a [NotifierProvider].
@internal
typedef ClassProviderFactory< //
        NotifierT,
        ProviderT,
        CreatedT,
        ArgT>
    = ProviderT Function(
  NotifierT Function() create, {
  required String? name,
  required Iterable<ProviderOrFamily>? dependencies,
  required Iterable<ProviderOrFamily>? allTransitiveDependencies,
  required RunNotifierBuild<NotifierT, CreatedT>? runNotifierBuildOverride,
  required bool isAutoDispose,
  required Family from,
  required ArgT argument,
  required Retry? retry,
  required Persist? persistOptions,
  required bool? shouldPersist,
});

/// A [Create] equivalent used by [Family].
@internal
typedef FamilyCreate<CreatedT, ArgT> = CreatedT Function(Ref ref, ArgT arg);

/// A base class for all families
abstract class Family extends ProviderOrFamily implements _FamilyOverride {
  /// A base class for all families
  const Family({
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  });

  @override
  Family get from => this;
}

/// Setup how a family is overridden
@internal
typedef SetupFamilyOverride<Arg> = void Function(
  Arg argument,
  void Function({
    required ProviderBase<Object?> origin,
    required ProviderBase<Object?> override,
  }),
);

/// A base implementation for [Family], used by the various providers to
/// help them define a [Family].
///
/// This API is not meant for public consumption.
@internal
class FunctionalFamily< //
    StateT,
    ArgT,
    CreatedT,
    ProviderT extends $FunctionalProvider<StateT, CreatedT>> extends Family {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const FunctionalFamily(
    this._createFn, {
    required FunctionalProviderFactory<ProviderT, CreatedT, ArgT>
        providerFactory,
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : _providerFactory = providerFactory;

  final FunctionalProviderFactory<ProviderT, CreatedT, ArgT> _providerFactory;

  final CreatedT Function(Ref ref, ArgT arg) _createFn;

  /// {@template family.call}
  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more information.
  /// {@endtemplate}
  ProviderT call(ArgT argument) {
    return _providerFactory(
      (ref) => _createFn(ref, argument),
      name: name,
      isAutoDispose: isAutoDispose,
      from: this,
      argument: argument,
      dependencies: null,
      allTransitiveDependencies: null,
      retry: retry,
    );
  }

  @override
  String? debugGetCreateSourceHash() => null;

  /// {@macro riverpod.override_with}
  Override overrideWith(
    CreatedT Function(Ref ref, ArgT arg) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ProviderT;

        return provider
            .$copyWithCreate((ref) => create(ref, provider.argument as ArgT))
            .$createElement(pointer);
      },
    );
  }

  @override
  String toString() => name ?? describeIdentity(this);
}

/// A base implementation for [Family] specific to `Notifier`-based providers.
///
/// It offers a unique "create" function which does not take any argument.
///
/// This API is not meant for public consumption.
@internal
class ClassFamily< //
        NotifierT extends NotifierBase< //
            StateT,
            CreatedT>,
        StateT,
        ArgT,
        CreatedT,
        ProviderT extends $ClassProvider<NotifierT, StateT, CreatedT>>
    extends Family {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const ClassFamily(
    this._createFn, {
    required this.providerFactory,
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
    required this.persistOptions,
    required this.shouldPersist,
  });

  @internal
  final ClassProviderFactory<NotifierT, ProviderT, CreatedT, ArgT>
      providerFactory;

  /// {@macro riverpod.persist}
  final Persist? persistOptions;

  /// {@macro riverpod.should_persist}
  final bool? shouldPersist;

  final NotifierT Function() _createFn;

  /// {@macro family.call}
  ProviderT call(ArgT argument) {
    return providerFactory(
      _createFn,
      name: name,
      isAutoDispose: isAutoDispose,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
      from: this,
      retry: retry,
      argument: argument,
      dependencies: null,
      allTransitiveDependencies: null,
      runNotifierBuildOverride: null,
    );
  }

  @override
  String? debugGetCreateSourceHash() => null;

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ProviderT;

        return provider.$copyWithCreate(create).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with}
  Override overrideWithBuild(
    RunNotifierBuild<NotifierT, CreatedT> build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ProviderT;

        return provider.$copyWithBuild(build).$createElement(pointer);
      },
    );
  }

  @override
  String toString() => name ?? describeIdentity(this);
}
