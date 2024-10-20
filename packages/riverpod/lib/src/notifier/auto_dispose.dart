part of '../notifier.dart';

/// An [AutoDisposeNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessAutoDisposeNotifier<State> extends NotifierBase<State> {
  @override
  late final AutoDisposeNotifierProviderElement<NotifierBase<State>, State>
      _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element = element
        as AutoDisposeNotifierProviderElement<NotifierBase<State>, State>;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  AutoDisposeNotifierProviderRef<State> get ref => _element;
}

/// {@macro riverpod.notifier}
///
/// {@macro riverpod.notifier_provider_modifier}
abstract class AutoDisposeNotifier<State>
    extends BuildlessAutoDisposeNotifier<State> {
  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  State build();
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeNotifierProviderRef<T>
    implements NotifierProviderRef<T>, AutoDisposeRef<T> {}

/// {@macro riverpod.notifier_provider}
///
/// {@macro riverpod.notifier_provider_modifier}
typedef AutoDisposeNotifierProvider<NotifierT extends AutoDisposeNotifier<T>, T>
    = AutoDisposeNotifierProviderImpl<NotifierT, T>;

/// The implementation of [AutoDisposeNotifierProvider] but with loosened type constraints
/// that can be shared with [NotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeNotifierProvider] and
/// [NotifierProvider] at the same time.
@internal
class AutoDisposeNotifierProviderImpl<NotifierT extends NotifierBase<T>, T>
    extends NotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.notifier_provider}
  ///
  /// {@macro riverpod.notifier_provider_modifier}
  AutoDisposeNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeNotifierProviderFamily.new;

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  AutoDisposeNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeNotifierProviderElement(this);
  }

  @override
  @mustBeOverridden
  T runNotifierBuild(NotifierBase<T> notifier) {
    return (notifier as AutoDisposeNotifier<T>).build();
  }

  /// {@macro riverpod.override_with}
  @mustBeOverridden
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeNotifierProviderImpl<NotifierT, T>.internal(
        create,
        from: from,
        argument: argument,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// The element of [AutoDisposeNotifierProvider]
class AutoDisposeNotifierProviderElement<NotifierT extends NotifierBase<T>, T>
    extends NotifierProviderElement<NotifierT, T>
    with
        AutoDisposeProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeNotifierProviderRef<T> {
  /// The [ProviderElementBase] for [NotifierProvider]
  @internal
  AutoDisposeNotifierProviderElement(super._provider);
}
