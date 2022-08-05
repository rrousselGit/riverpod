part of '../framework.dart';

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
    required this.disposeDelay,
  }) : super(name: name, from: from, argument: argument);

  /// {@template riverpod.cache_time}
  /// The minimum amount of time before an `autoDispose` provider can be
  /// disposed if not listened after the last value change.
  ///
  /// If the provider rebuilds (such as when using `ref.watch` or `ref.refresh`)
  /// or emits a new value, the timer will be refreshed.
  ///
  /// If null, use the nearest ancestor [ProviderContainer]'s [cacheTime].
  /// If no ancestor is found, fallbacks to [Duration.zero].
  /// {@endtemplate}
  final Duration? cacheTime;

  /// {@template riverpod.dispose_delay}
  /// The amount of time before a provider is disposed after its last listener
  /// is removed.
  ///
  /// If a new listener is added within that duration, the provider will not be
  /// disposed.
  ///
  /// If null, use the nearest ancestor [ProviderContainer]'s [disposeDelay].
  /// If no ancestor is found, fallbacks to [Duration.zero].
  /// {@endtemplate}
  final Duration? disposeDelay;

  @override
  State create(AutoDisposeRef ref);

  @override
  AutoDisposeProviderElementBase<State> createElement();
}

/// The [ProviderElementBase] of an [AutoDisposeProviderBase].
abstract class AutoDisposeProviderElementBase<State>
    extends ProviderElementBase<State> implements AutoDisposeRef<State> {
  /// The [ProviderElementBase] of an [AutoDisposeProviderBase].
  AutoDisposeProviderElementBase(ProviderBase<State> provider)
      : super(provider);

  List<KeepAliveLink>? _keepAliveLinks;

  bool _maintainState = false;

  late final _cacheTime =
      (provider as AutoDisposeProviderBase).cacheTime ?? _container.cacheTime;

  late final _disposeDelay =
      (provider as AutoDisposeProviderBase).disposeDelay ??
          _container.disposeDelay;

  @Deprecated('Use `keepAlive()` instead')
  @override
  bool get maintainState => _maintainState;
  @override
  set maintainState(bool value) {
    _maintainState = value;
    if (!value) mayNeedDispose();
  }

  Timer? _cacheTimer;

  KeepAliveLink? _disposeDelayLink;
  Timer? _disposeDelayTimer;

  @override
  KeepAliveLink keepAlive() {
    final links = _keepAliveLinks ??= [];

    late KeepAliveLink link;
    link = KeepAliveLink._(() {
      if (links.remove(link)) {
        if (links.isEmpty) mayNeedDispose();
      }
    });
    links.add(link);

    return link;
  }

  @override
  void mayNeedDispose() {
    final links = _keepAliveLinks;

    // ignore: deprecated_member_use_from_same_package
    if (!maintainState && !hasListeners && (links == null || links.isEmpty)) {
      _container._scheduler.scheduleProviderDispose(this);
    }
  }

  @override
  void _buildState() {
    super._buildState();

    if (_disposeDelay != Duration.zero) {
      // TODO timer should not refresh when provider rebuilds
      // TODO adding a new listener cancels the timer

      // If we have a previous link and the provider was refreshed,
      // then that link was removed. So it's safe to replace the link with a
      // new one
      assert(
        _disposeDelayLink == null ||
            _keepAliveLinks == null ||
            !_keepAliveLinks!.contains(_disposeDelayLink),
        'Bad state',
      );
      _disposeDelayLink = keepAlive();

      onCancel(() {
        assert(_disposeDelayLink != null, 'Bad state');
        assert(_disposeDelayTimer == null, 'Bad state');
        _disposeDelayTimer = Timer(_disposeDelay, () {
          _disposeDelayTimer = null;
          _disposeDelayLink!.close();
          _disposeDelayLink = null;
        });
      });

      onResume(() {
        _disposeDelayTimer?.cancel();
        _disposeDelayTimer = null;
        _disposeDelayLink ??= keepAlive();
      });

      // We don't cancel the timer on dispose
      // as we voluntarily want the disposeDelay logic to be independent from
      // when the last value was emitted.
    }

    if (_cacheTime != Duration.zero) {
      // Safe to have as a local variable since links are cleared
      // on rebuild
      KeepAliveLink? link;

      listenSelf((previous, next) {
        link ??= keepAlive();
        _cacheTimer?.cancel();

        _cacheTimer = Timer(_cacheTime, () {
          link!.close();
          link = null;
          _cacheTimer = null;

          // will always be initialized so `!` is safe
          // requireState is safe because if an error is emitted, the timer
          // will be cancelled anyway
          final state = _state!.requireState;
          if (state is AsyncValue) {
            _state = Result.data(state.unwrapPrevious() as State);
          }
        });
      }, onError: (err, stack) {
        link ??= keepAlive();
        _cacheTimer?.cancel();

        _cacheTimer = Timer(_cacheTime, () {
          link!.close();
          link = null;
          _cacheTimer = null;
        });
      });

      // No need for an onDispose logic, as onDispose will not be executing
      // unless the timer completes or the provider is refreshed.
      // But if the provider is refreshed, a new value will be sent, clearing
      // the previous timer anyway
    }
  }

  @override
  void _runOnDispose() {
    _keepAliveLinks?.clear();
    super._runOnDispose();
    assert(
      _keepAliveLinks == null || _keepAliveLinks!.isEmpty,
      'Cannot call keepAlive() within onDispose listeners',
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Since there's no onDispose for the timers, we need to manually handle the
    // case where the ProviderContainer is disposed when the provider is still alive.
    _cacheTimer?.cancel();
    _cacheTimer = null;
    _disposeDelayTimer?.cancel();
    _disposeDelayTimer = null;
  }
}

/// A object which maintains a provider alive
class KeepAliveLink {
  KeepAliveLink._(this._close);

  final void Function() _close;

  /// Release this [KeepAliveLink], allowing the associated provider to
  /// be disposed if the provider is no-longer listener nor has any
  /// remaining [KeepAliveLink].
  void close() => _close();
}
