part of '../framework.dart';

/// A typedef representing the constructor of any classical provider.
@internal
typedef ProviderCreate<ProviderT, Created, RefT extends Ref> = ProviderT
    Function(
  Create<Created, RefT> create, {
  required String? name,
  required Iterable<ProviderOrFamily>? dependencies,
  required Iterable<ProviderOrFamily>? allTransitiveDependencies,
  required DebugGetCreateSourceHash? debugGetCreateSourceHash,
  required bool isAutoDispose,
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
  required Iterable<ProviderOrFamily>? allTransitiveDependencies,
  required DebugGetCreateSourceHash? debugGetCreateSourceHash,
  required bool isAutoDispose,
  Family<Object?> from,
  Object? argument,
});

/// A [Create] equivalent used by [Family].
@internal
typedef FamilyCreate<T, R extends Ref, Arg> = T Function(R ref, Arg arg);

/// A base class for all families
@optionalTypeArgs
abstract mixin class Family<
        @Deprecated(
          'The generic parameter will be removed in version 3.0.0. '
          'This is to enable riverpod_generator to implement families with generic parameters',
        )
        // ignore: deprecated_member_use_from_same_package
        State>
    implements
        FamilyOverride<
            // ignore: deprecated_member_use_from_same_package
            State>,
        ProviderOrFamily,
        AnyProviderOrFamily {
  /// A base class for all families
  const Family();

  @override
  Family<Object?>? get from => null;

  @override
  // ignore: deprecated_member_use_from_same_package
  Family<State> get overriddenFamily => this;

  @override
  String? debugGetCreateSourceHash() => null;
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

  @override
  String? debugGetCreateSourceHash() => null;
}

/// A base implementation for [Family], used by the various providers to
/// help them define a [Family].
///
/// This API is not meant for public consumption.
@internal
class FamilyBase<RefT extends Ref<R>, R, Arg, Created,
        ProviderT extends ProviderBase<R>> extends ProviderOrFamily
    with Family<R>, _FamilyMixin<R, Arg, ProviderT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const FamilyBase(
    this._createFn, {
    required ProviderCreate<ProviderT, Created, RefT> providerFactory,
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required DebugGetCreateSourceHash? debugGetCreateSourceHash,
  })  : _providerFactory = providerFactory,
        _debugGetCreateSourceHash = debugGetCreateSourceHash;

  final ProviderCreate<ProviderT, Created, RefT> _providerFactory;

  final Created Function(RefT ref, Arg arg) _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        (ref) => _createFn(ref, argument),
        name: name,
        from: this,
        isAutoDispose: isAutoDispose,
        argument: argument,
        dependencies: dependencies,
        allTransitiveDependencies: allTransitiveDependencies,
        debugGetCreateSourceHash: debugGetCreateSourceHash,
      );

  final DebugGetCreateSourceHash? _debugGetCreateSourceHash;
  @override
  String? debugGetCreateSourceHash() => _debugGetCreateSourceHash?.call();
}

/// A base implementation for [Family] specific to `Notifier`-based providers.
///
/// It offers a unique "create" function which does not take any argument.
///
/// This API is not meant for public consumption.
@internal
class NotifierFamilyBase<RefT extends Ref<R>, R, Arg, NotifierT,
        ProviderT extends ProviderBase<R>> extends ProviderOrFamily
    with Family<R>, _FamilyMixin<R, Arg, ProviderT> {
  /// A base implementation for [Family], used by the various providers to
  /// help them define a [Family].
  ///
  /// This API is not meant for public consumption.
  const NotifierFamilyBase(
    this._createFn, {
    required ProviderNotifierCreate<ProviderT, NotifierT, RefT> providerFactory,
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required DebugGetCreateSourceHash? debugGetCreateSourceHash,
  })  : _providerFactory = providerFactory,
        _debugGetCreateSourceHash = debugGetCreateSourceHash;

  final ProviderNotifierCreate<ProviderT, NotifierT, RefT> _providerFactory;

  final NotifierT Function() _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        _createFn,
        name: name,
        from: this,
        isAutoDispose: isAutoDispose,
        argument: argument,
        dependencies: dependencies,
        allTransitiveDependencies: allTransitiveDependencies,
        debugGetCreateSourceHash: debugGetCreateSourceHash,
      );

  final DebugGetCreateSourceHash? _debugGetCreateSourceHash;
  @override
  String? debugGetCreateSourceHash() => _debugGetCreateSourceHash?.call();
}
