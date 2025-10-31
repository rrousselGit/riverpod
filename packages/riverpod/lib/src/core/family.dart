part of '../framework.dart';

/// A typedef representing the constructor of any classical provider.
@internal
typedef FunctionalProviderFactory<
  //
  ProviderT,
  CreatedT,
  ArgT
> =
    ProviderT Function(
      Create<CreatedT> create, {
      required String? name,
      required List<ProviderOrFamily>? dependencies,
      required List<ProviderOrFamily>? $allTransitiveDependencies,
      required bool isAutoDispose,
      required Family from,
      required ArgT argument,
      required Retry? retry,
    });

/// A typedef representing the constructor of a [NotifierProvider].
@internal
typedef ClassProviderFactory<
  //
  NotifierT,
  ProviderT,
  CreatedT,
  ArgT
> =
    ProviderT Function(
      NotifierT Function() create, {
      required String? name,
      required Iterable<ProviderOrFamily>? dependencies,
      required Iterable<ProviderOrFamily>? $allTransitiveDependencies,
      required bool isAutoDispose,
      required Family from,
      required ArgT argument,
      required Retry? retry,
    });

/// A [Create] equivalent used by [Family].
@internal
typedef FamilyCreate<CreatedT, ArgT> = CreatedT Function(Ref ref, ArgT arg);

/// A base class for all families
@publicInMisc
final class Family extends ProviderOrFamily implements _FamilyOverride {
  /// A base class for all families
  Family({
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  });

  @override
  Family get from => this;

  @override
  String toString() => name ?? describeIdentity(this);
}

@publicInCodegen
@reopen
@internal
base class $Family extends Family {
  /// A base class for all families
  $Family({
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  });

  @override
  String toString() => name ?? describeIdentity(this);
}

/// Setup how a family is overridden
@internal
typedef SetupFamilyOverride<ArgT> =
    void Function(
      ArgT argument,
      void Function({
        required $ProviderBaseImpl<Object?> origin,
        required $ProviderBaseImpl<Object?> override,
      }),
    );

@internal
@publicInCodegen
base mixin $FunctionalFamilyOverride<CreatedT, ArgT> on Family {
  /// {@macro riverpod.override_with}
  Override overrideWith(CreatedT Function(Ref ref, ArgT arg) create) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider =
            pointer.origin as $FunctionalProvider<Object?, Object?, CreatedT>;

        return provider
            .$view(create: (ref) => create(ref, provider.argument as ArgT))
            .$createElement(pointer);
      },
    );
  }
}

/// A base implementation for [Family], used by the various providers to
/// help them define a [Family].
///
/// This API is not meant for public consumption.
@internal
@reopen
base class FunctionalFamily<
  //
  StateT,
  ValueT,
  ArgT,
  CreatedT,
  ProviderT extends $FunctionalProvider<StateT, ValueT, CreatedT>
>
    extends Family
    with $FunctionalFamilyOverride<CreatedT, ArgT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  FunctionalFamily(
    this._createFn, {
    required FunctionalProviderFactory<ProviderT, CreatedT, ArgT>
    providerFactory,
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
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
      $allTransitiveDependencies: null,
      retry: retry,
    );
  }
}

@internal
@publicInCodegen
base mixin $ClassFamilyOverride<
  NotifierT extends AnyNotifier<StateT, ValueT>,
  StateT,
  ValueT,
  CreatedT,
  ArgT
>
    on Family {
  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider =
            pointer.origin
                as $ClassProvider<NotifierT, StateT, ValueT, CreatedT>;

        return provider.$view(create: create).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with}
  Override overrideWithBuild(RunNotifierBuild<NotifierT, CreatedT> build) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider =
            pointer.origin
                as $ClassProvider<NotifierT, StateT, ValueT, CreatedT>;

        return provider
            .$view(runNotifierBuildOverride: build)
            .$createElement(pointer);
      },
    );
  }
}

/// A base implementation for [Family] specific to `Notifier`-based providers.
///
/// It offers a unique "create" function which does not take any argument.
///
/// This API is not meant for public consumption.
@internal
@reopen
base class ClassFamily<
  //
  NotifierT extends AnyNotifier<StateT, ValueT>,
  StateT,
  ValueT,
  ArgT,
  CreatedT,
  ProviderT extends $ClassProvider<NotifierT, StateT, ValueT, CreatedT>
>
    extends Family
    with $ClassFamilyOverride<NotifierT, StateT, ValueT, CreatedT, ArgT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  ClassFamily(
    this._createFn, {
    required ClassProviderFactory<NotifierT, ProviderT, CreatedT, ArgT>
    providerFactory,
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : _providerFactory = providerFactory;

  final ClassProviderFactory<NotifierT, ProviderT, CreatedT, ArgT>
  _providerFactory;

  final NotifierT Function(ArgT arg) _createFn;

  /// {@macro family.call}
  ProviderT call(ArgT argument) {
    return _providerFactory(
      () => _createFn(argument),
      name: name,
      isAutoDispose: isAutoDispose,
      from: this,
      retry: retry,
      argument: argument,
      dependencies: null,
      $allTransitiveDependencies: null,
    );
  }
}
