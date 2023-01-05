part of '../framework.dart';

/// A [Create] equivalent used by [Family].
@internal
typedef FamilyCreate<T, R extends Ref, Arg> = T Function(
  R ref,
  Arg arg,
);

/// A base class for all families
abstract class Family<State> extends ProviderOrFamily
    implements FamilyOverride<State> {
  /// A base class for all families
  const Family();

  @override
  List<ProviderOrFamily>? get dependencies;

  /// The family name.
  @protected
  String? get name;

  @override
  Family<Object?>? get from => null;

  @override
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
    required ProviderBase origin,
    required ProviderBase override,
  }),
);

/// Do not use: Internal object to used by [ProviderContainer]/`ProviderScope`
/// to override the behavior of a "family" for part of the application.
@internal
abstract class FamilyOverride<State> implements Override {
  /// The family that was overridden.
  Family<State> get overriddenFamily;

  /// Obtains the new behavior for a provider associated to the overridden family.
  @visibleForOverriding
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
  FamilyBase(
    this._createFn, {
    required ProviderT Function(
      Create<Created, RefT> create, {
      String? name,
      Family from,
      Object? argument,
      List<ProviderOrFamily>? dependencies,
    })
        providerFactory,
    required this.name,
    required this.dependencies,
  }) : _providerFactory = providerFactory;

  final ProviderT Function(
    Create<Created, RefT> create, {
    String? name,
    Family from,
    Object? argument,
    List<ProviderOrFamily>? dependencies,
  }) _providerFactory;

  final Created Function(RefT ref, Arg arg) _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        (ref) => _createFn(ref, argument),
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
      );

  @override
  final String? name;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  late final List<ProviderOrFamily>? allTransitiveDependencies =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);
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
  AutoDisposeFamilyBase(
    this._createFn, {
    required ProviderT Function(
      Create<Created, RefT> create, {
      String? name,
      Family from,
      Object? argument,
      List<ProviderOrFamily>? dependencies,
    })
        providerFactory,
    required this.name,
    required this.dependencies,
  }) : _providerFactory = providerFactory;

  final ProviderT Function(
    Create<Created, RefT> create, {
    String? name,
    Family from,
    Object? argument,
    List<ProviderOrFamily>? dependencies,
  }) _providerFactory;

  final Created Function(RefT ref, Arg arg) _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        (ref) => _createFn(ref, argument),
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
      );

  @override
  final String? name;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  late final List<ProviderOrFamily>? allTransitiveDependencies =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);
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
  AutoDisposeNotifierFamilyBase(
    this._createFn, {
    required ProviderT Function(
      NotifierT Function() create, {
      String? name,
      Family from,
      Object? argument,
      List<ProviderOrFamily>? dependencies,
    })
        providerFactory,
    required this.name,
    required this.dependencies,
  }) : _providerFactory = providerFactory;

  final ProviderT Function(
    NotifierT Function() create, {
    String? name,
    Family from,
    Object? argument,
    List<ProviderOrFamily>? dependencies,
  }) _providerFactory;

  final NotifierT Function() _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        _createFn,
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
      );

  @override
  final String? name;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  late final List<ProviderOrFamily>? allTransitiveDependencies =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);
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
  NotifierFamilyBase(
    this._createFn, {
    required ProviderT Function(
      NotifierT Function() create, {
      String? name,
      Family from,
      Object? argument,
      List<ProviderOrFamily>? dependencies,
    })
        providerFactory,
    required this.name,
    required this.dependencies,
  }) : _providerFactory = providerFactory;

  final ProviderT Function(
    NotifierT Function() create, {
    String? name,
    Family from,
    Object? argument,
    List<ProviderOrFamily>? dependencies,
  }) _providerFactory;

  final NotifierT Function() _createFn;

  @override
  ProviderT call(Arg argument) => _providerFactory(
        _createFn,
        name: name,
        from: this,
        argument: argument,
        dependencies: dependencies,
      );

  @override
  final String? name;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  late final List<ProviderOrFamily>? allTransitiveDependencies =
      dependencies == null ? null : _allTransitiveDependencies(dependencies!);
}
