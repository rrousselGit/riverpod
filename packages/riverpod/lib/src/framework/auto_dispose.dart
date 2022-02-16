part of '../framework.dart';

/// A [Ref] for providers that are automatically destroyed when
/// no longer used.
///
/// The difference with [Ref] is that it has an extra
/// [keepAlive] function to help determine if the state can be destroyed
///  or not.
abstract class AutoDisposeRef extends Ref {
  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `false`,
  /// may destroy the provider state if it currently has no listeners.
  ///
  /// Defaults to `false`.
  @Deprecated('use keepAlive() instead')
  bool get maintainState;

  @Deprecated('use keepAlive() instead')
  set maintainState(bool value);

  /// Requests for the state of a provider to not be disposed when all the
  /// listeners of the provider are removed.
  ///
  /// Returns an object which allows cancelling this operation, therefore
  /// allowing the provider to dispose itself when all listeners are removed.
  ///
  /// If [keepAlive] is invoked multiple times, all [KeepAliveLink] will have
  /// to be closed for the provider to dispose itself when all listeners are removed.
  KeepAliveLink keepAlive();

  @override
  T watch<T>(
    // can watch both auto-dispose and non-auto-dispose providers
    ProviderListenable<T> provider,
  );

  @override
  ProviderSubscription<T> listen<T>(
    // overridden to allow AutoDisposeProviderBase
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    bool fireImmediately,
    void Function(Object error, StackTrace stackTrace)? onError,
  });
}

/// {@template riverpod.AutoDisposeProviderBase}
/// A base class for providers that destroy their state when no longer listened to.
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
    required this.cacheTime,
  }) : super(name: name, from: from, argument: argument);

  /// {@template riverpod.cache_time}
  /// The minimum amount of time before an `autoDispose` provider can be
  /// disposed if not listened.
  ///
  /// If the provider rebuilds (such as when using `ref.watch` or `ref.refresh`),
  /// the timer will be refreshed.
  ///
  /// If null, use the nearest ancestor [ProviderContainer]'s [cacheTime].
  /// If no ancestor is found, fallbacks to [Duration.zero].
  /// {@endtemplate}
  final Duration? cacheTime;

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

  // TODO make nullable
  final _keepAliveLinks = <KeepAliveLink>[];

  bool _maintainState = false;

  late final _cacheTime =
      (provider as AutoDisposeProviderBase).cacheTime ?? _container.cacheTime;

  @Deprecated('Use `keepAlive()` instead')
  @override
  bool get maintainState => _maintainState;
  @override
  set maintainState(bool value) {
    _maintainState = value;
    if (!value) mayNeedDispose();
  }

  @override
  KeepAliveLink keepAlive() {
    late KeepAliveLink link;

    link = KeepAliveLink._(() {
      _keepAliveLinks.remove(link);
      if (_keepAliveLinks.isEmpty) mayNeedDispose();
    });
    _keepAliveLinks.add(link);

    return link;
  }

  @override
  void mayNeedDispose() {
    // ignore: deprecated_member_use_from_same_package
    if (!maintainState && !hasListeners && _keepAliveLinks.isEmpty) {
      _container._scheduler.scheduleProviderDispose(this);
    }
  }

  @override
  void _buildState() {
    super._buildState();
    if (_cacheTime != Duration.zero) {
      final link = keepAlive();
      final timer = Timer(_cacheTime, link.close);
      onDispose(timer.cancel);
    }
  }

  @override
  void _runOnDispose() {
    _keepAliveLinks.clear();
    super._runOnDispose();
    assert(
      _keepAliveLinks.isEmpty,
      'Cannot call keepAlive() within onDispose listeners',
    );
  }
}

/// A object which maintains a provider alive
class KeepAliveLink {
  KeepAliveLink._(this._close);

  final void Function() _close;

  /// Release this [KeepAliveLink], allowing the associated provider to
  /// be disposed if the provider is no-longer listener nor has any
  /// remaning [KeepAliveLink].
  void close() => _close();
}
