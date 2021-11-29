part of '../framework.dart';

/// A [Ref] for providers that are automatically destroyed when
/// no-longer used.
///
/// The difference with [Ref] is that it has an extra
/// [maintainState] property, to help determine if the state can be destroyed
///  or not.
abstract class AutoDisposeRef extends Ref {
  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `false`,
  /// may destroy the provider state if it currently has no listeners.
  ///
  /// Defaults to `false`.
  bool get maintainState;
  // TODO deprecate in favour of "keepAlive().cancel()"
  set maintainState(bool value);

  @override
  T watch<T>(
    // can watch both auto-dispose and non-auto-dispose providers
    ProviderListenable<T> provider,
  );

  @override
  void Function() listen<T>(
    // overridden to allow AutoDisposeProviderBase
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    bool fireImmediately,
    void Function(Object error, StackTrace stackTrace)? onError,
  });
}

/// {@template riverpod.AutoDisposeProviderBase}
/// A base class for providers that destroy their state when no-longer listened.
///
/// See also:
///
/// - [Provider.autoDispose], a variant of [Provider] that auto-dispose its state.
/// {@endtemplate}
abstract class AutoDisposeProviderBase<State> extends ProviderBase<State> {
  /// {@macro riverpod.AutoDisposeProviderBase}
  AutoDisposeProviderBase({
    required String? name,
    required Family? from,
    required Object? argument,
  }) : super(name: name, from: from, argument: argument);

  @override
  State create(AutoDisposeRef ref);

  @override
  AutoDisposeProviderElementBase<State> createElement();
}

/// The [ProviderElementBase] of an [AutoDisposeProviderBase].
abstract class AutoDisposeProviderElementBase<State>
    extends ProviderElementBase<State> implements AutoDisposeRef {
  /// The [ProviderElementBase] of an [AutoDisposeProviderBase].
  AutoDisposeProviderElementBase(ProviderBase<State> provider)
      : super(provider);

  bool _maintainState = false;
  @override
  bool get maintainState => _maintainState;
  @override
  set maintainState(bool value) {
    _maintainState = value;
    if (!_maintainState && !hasListeners) {
      _container._scheduler.scheduleProviderDispose(this);
    }
  }

  @override
  void mayNeedDispose() {
    if (!maintainState && !hasListeners) {
      _container._scheduler.scheduleProviderDispose(this);
    }
  }
}
