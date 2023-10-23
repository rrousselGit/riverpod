part of '../framework.dart';

/// A typedef representing the constructor of any classical provider.
@internal
typedef ProviderCreate<ProviderT, Created, RefT extends Ref> = ProviderT
    Function(
  Create<Created, RefT> create, {
  required String? name,
  required Iterable<ProviderOrFamily>? dependencies,
  required Set<ProviderOrFamily>? allTransitiveDependencies,
  required DebugGetCreateSourceHash? debugGetCreateSourceHash,
  Family<Object?> from,
  Object? argument,
});

/// A typedef representing the constructor of a [NotifierProvider].
@internal
typedef ProviderNotifierCreate<ProviderT, Created, RefT extends Ref> = ProviderT
    Function(
  Created Function() create, {
  required String? name,
  required Iterable<ProviderOrFamily>? dependencies,
  required Set<ProviderOrFamily>? allTransitiveDependencies,
  required DebugGetCreateSourceHash? debugGetCreateSourceHash,
  Family<Object?> from,
  Object? argument,
});

/// A [Create] equivalent used by [Family].
@internal
typedef FamilyCreate<T, R extends Ref, Arg> = T Function(R ref, Arg arg);

/// A base class for all families
abstract class Family<
    @Deprecated(
      'The generic parameter will be removed in version 3.0.0. '
      'This is to enable riverpod_generator to implement families with generic parameters',
    )
    // ignore: deprecated_member_use_from_same_package
    State> implements FamilyOverride<State>, ProviderOrFamily {
  /// A base class for all families
  const Family();

  @override
  Family<Object?>? get from => null;

  @override
  // ignore: deprecated_member_use_from_same_package
  Family<State> get overriddenFamily => this;
}

mixin _FamilyMixin<State, Arg, FamilyProvider extends ProviderBase<State>>
    on Family<State> {
  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferably override `==`/`hashCode`.
  /// See the documentation of [Provider.family] for more information.
  FamilyProvider call(Arg argument);

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overrideWith}
  Override overrideWithProvider(
    FamilyProvider Function(Arg argument) override,
  ) {
    return FamilyOverrideImpl<State, Arg, FamilyProvider>(this, override);
  }

  @visibleForOverriding
  @override
  ProviderBase<State> getProviderOverride(ProviderBase<State> provider) {
    return call(provider.argument as Arg);
  }
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

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
@internal
abstract class FamilyOverride<@Deprecated('Will be removed in 3.0.0') State>
    implements Override {
  /// The family that was overridden.
  // ignore: deprecated_member_use_from_same_package
  Family<State> get overriddenFamily;

  /// Obtains the new behavior for a provider associated to the overridden family.
  @visibleForOverriding
  // ignore: deprecated_member_use_from_same_package
  ProviderBase<State> getProviderOverride(ProviderBase<State> provider);
}

/// An [Override] for families
@internal
class FamilyOverrideImpl<State, Arg, FamilyProvider extends ProviderBase<State>>
    implements FamilyOverride<State> {
  /// An [Override] for families
  // ignore: library_private_types_in_public_api
  FamilyOverrideImpl(this.overriddenFamily, this._newCreate);

  final FamilyProvider Function(Arg arg) _newCreate;

  @override
  // ignore: library_private_types_in_public_api
  final _FamilyMixin<State, Arg, FamilyProvider> overriddenFamily;

  @visibleForOverriding
  @override
  ProviderBase<State> getProviderOverride(ProviderBase<State> provider) {
    final arg = provider.argument as Arg;
    return _newCreate(arg);
  }
}

/// A base implementation for [Family], used by the various providers to
/// help them define a [Family].
///
/// This API is not meant for public consumption.
@internal
class FamilyBase<RefT extends Ref<R>, R, Arg, Created,
        ProviderT extends ProviderBase<R>> extends Family<R>
    with _FamilyMixin<R, Arg, ProviderT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const FamilyBase(
    this._createFn, {
    required ProviderCreate<ProviderT, Created, RefT> providerFactory,
    required this.name,
    required this.dependencies,
    required this.allTransitiveDependencies,
    required this.debugGetCreateSourceHash,
  }) : _providerFactory = providerFactory;

  final ProviderCreate<ProviderT, Created, RefT> _providerFactory;

  final Created Function(RefT ref, Arg arg) _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        (ref) => _createFn(ref, argument),
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
        allTransitiveDependencies: allTransitiveDependencies,
        debugGetCreateSourceHash: debugGetCreateSourceHash,
      );

  @override
  final String? name;
  @override
  final Iterable<ProviderOrFamily>? dependencies;
  @override
  final Set<ProviderOrFamily>? allTransitiveDependencies;

  /// {@macro riverpod.create_source_hash}
  @internal
  final DebugGetCreateSourceHash? debugGetCreateSourceHash;
}

/// A base implementation for [Family], used by the various providers to
/// help them define a [Family].
///
/// This API is not meant for public consumption.

@internal
class AutoDisposeFamilyBase<RefT extends Ref<R>, R, Arg, Created,
        ProviderT extends ProviderBase<R>> extends Family<R>
    with _FamilyMixin<R, Arg, ProviderT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const AutoDisposeFamilyBase(
    this._createFn, {
    required ProviderCreate<ProviderT, Created, RefT> providerFactory,
    required this.name,
    required this.dependencies,
    required this.allTransitiveDependencies,
    required this.debugGetCreateSourceHash,
  }) : _providerFactory = providerFactory;

  final ProviderCreate<ProviderT, Created, RefT> _providerFactory;

  final Created Function(RefT ref, Arg arg) _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        (ref) => _createFn(ref, argument),
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
        allTransitiveDependencies: allTransitiveDependencies,
        debugGetCreateSourceHash: debugGetCreateSourceHash,
      );

  @override
  final String? name;
  @override
  final Iterable<ProviderOrFamily>? dependencies;
  @override
  final Set<ProviderOrFamily>? allTransitiveDependencies;

  /// {@macro riverpod.create_source_hash}
  @internal
  final DebugGetCreateSourceHash? debugGetCreateSourceHash;
}

/// A base implementation for [Family] specific to autoDispose `Notifier`-based providers.
///
/// It offers a unique "create" function which does not take any argument.
///
/// This API is not meant for public consumption.
@internal
class AutoDisposeNotifierFamilyBase<RefT extends Ref<R>, R, Arg, NotifierT,
        ProviderT extends ProviderBase<R>> extends Family<R>
    with _FamilyMixin<R, Arg, ProviderT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const AutoDisposeNotifierFamilyBase(
    this._createFn, {
    required ProviderNotifierCreate<ProviderT, NotifierT, RefT> providerFactory,
    required this.name,
    required this.dependencies,
    required this.allTransitiveDependencies,
    required this.debugGetCreateSourceHash,
  }) : _providerFactory = providerFactory;

  final ProviderNotifierCreate<ProviderT, NotifierT, RefT> _providerFactory;

  final NotifierT Function() _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        _createFn,
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
        allTransitiveDependencies: allTransitiveDependencies,
        debugGetCreateSourceHash: debugGetCreateSourceHash,
      );

  @override
  final String? name;
  @override
  final Iterable<ProviderOrFamily>? dependencies;
  @override
  final Set<ProviderOrFamily>? allTransitiveDependencies;

  /// {@macro riverpod.create_source_hash}
  @internal
  final DebugGetCreateSourceHash? debugGetCreateSourceHash;
}

/// A base implementation for [Family] specific to `Notifier`-based providers.
///
/// It offers a unique "create" function which does not take any argument.
///
/// This API is not meant for public consumption.
@internal
class NotifierFamilyBase<RefT extends Ref<R>, R, Arg, NotifierT,
        ProviderT extends ProviderBase<R>> extends Family<R>
    with _FamilyMixin<R, Arg, ProviderT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const NotifierFamilyBase(
    this._createFn, {
    required ProviderNotifierCreate<ProviderT, NotifierT, RefT> providerFactory,
    required this.name,
    required this.dependencies,
    required this.allTransitiveDependencies,
    required this.debugGetCreateSourceHash,
  }) : _providerFactory = providerFactory;

  final ProviderNotifierCreate<ProviderT, NotifierT, RefT> _providerFactory;

  final NotifierT Function() _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        _createFn,
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
        allTransitiveDependencies: allTransitiveDependencies,
        debugGetCreateSourceHash: debugGetCreateSourceHash,
      );

  @override
  final String? name;
  @override
  final Iterable<ProviderOrFamily>? dependencies;
  @override
  final Set<ProviderOrFamily>? allTransitiveDependencies;

  /// {@macro riverpod.create_source_hash}
  @internal
  final DebugGetCreateSourceHash? debugGetCreateSourceHash;
}
