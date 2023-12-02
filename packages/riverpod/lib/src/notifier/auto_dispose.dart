part of '../notifier.dart';

/// An [AutoDisposeNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessAutoDisposeNotifier<State> extends NotifierBase<State> {
  @override
  AutoDisposeNotifierProviderElement<NotifierBase<State>, State>? _element;

  @override
  void _setElement(ProviderElementBase<State>? element) {
    if (_element != null && element != null) {
      throw StateError(alreadyInitializedError);
    }
    _element = element
        as AutoDisposeNotifierProviderElement<NotifierBase<State>, State>?;
  }

  @override
  AutoDisposeNotifierProviderRef<State> get ref {
    final element = _element;
    if (element == null) throw StateError(uninitializedElementError);

    return element;
  }
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
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
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
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeNotifierProviderRef<T> {
  /// The [ProviderElementBase] for [NotifierProvider]
  @internal
  AutoDisposeNotifierProviderElement(super._provider);
}
