part of '../notifier.dart';

abstract class AutoDisposeNotifier<State> extends NotifierBase<State> {
  @override
  late final AutoDisposeNotifierProviderElement<AutoDisposeNotifier<State>,
      State> _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element = element as AutoDisposeNotifierProviderElement<
        AutoDisposeNotifier<State>, State>;
  }

  @override
  AutoDisposeNotifierProviderRef<State> get ref => _element;

  @visibleForOverriding
  State build();
}

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeNotifierProviderRef<T>
    implements NotifierProviderRef<T>, AutoDisposeRef<T> {}

/// {@macro riverpod.notifier}
typedef AutoDisposeNotifierProvider<NotifierT extends AutoDisposeNotifier<T>, T>
    = TestAutoDisposeNotifierProvider<NotifierT, T>;

/// The implementation of [AutoDisposeNotifierProvider] but with loosened type constraints
/// that can be shared with [NotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeNotifierProvider] and
/// [NotifierProvider] at the same time.
class TestAutoDisposeNotifierProvider<NotifierT extends NotifierBase<T>, T>
    extends NotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.notifier}
  TestAutoDisposeNotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
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
  T _runNotifierBuild(
    covariant AutoDisposeNotifier<T> notifier,
  ) {
    return notifier.build();
  }
}

class AutoDisposeNotifierProviderElement<NotifierT extends NotifierBase<T>,
        T> = NotifierProviderElement<NotifierT, T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeNotifierProviderRef<T>;
