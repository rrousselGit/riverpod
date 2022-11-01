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
  AutoDisposeNotifierProviderRef<State> get ref => _element;
}

/// {@template riverpod.notifier}
abstract class AutoDisposeNotifier<State>
    extends BuildlessAutoDisposeNotifier<State> {
  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  State build();
}

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeNotifierProviderRef<T>
    implements NotifierProviderRef<T>, AutoDisposeRef<T> {}

/// {@macro riverpod.notifier}
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
  /// {@macro riverpod.notifier}
  AutoDisposeNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeNotifierProviderFamily.new;

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  AutoDisposeNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeNotifierProviderElement._(this);
  }

  @override
  T runNotifierBuild(NotifierBase<T> notifier) {
    return (notifier as AutoDisposeNotifier<T>).build();
  }

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeNotifierProviderImpl<NotifierT, T>(
        create,
        from: from,
        argument: argument,
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
  AutoDisposeNotifierProviderElement._(super.provider) : super._();
}
