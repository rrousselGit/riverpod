part of '../framework.dart';

/// A mixin that adds auto dispose support to a [ProviderElementBase].
@internal
mixin AutoDisposeProviderElementMixin<State> on ProviderElementBase<State>
    implements AutoDisposeRef<State> {
  List<KeepAliveLink>? _keepAliveLinks;

  bool _maintainState = false;
  @Deprecated('Use `keepAlive()` instead')
  @override
  bool get maintainState => _maintainState;
  @override
  set maintainState(bool value) {
    _maintainState = value;
    if (!value) mayNeedDispose();
  }

  late final _cacheTime = provider.cacheTime ?? _container.cacheTime;

  late final _disposeDelay = provider.disposeDelay ?? _container.disposeDelay;

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
  void buildState() {
    super.buildState();

    if (_disposeDelay != 0) {
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
        _disposeDelayTimer = Timer(Duration(milliseconds: _disposeDelay), () {
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

    if (_cacheTime != 0) {
      // Safe to have as a local variable since links are cleared
      // on rebuild
      KeepAliveLink? link;

      listenSelf((previous, next) {
        link ??= keepAlive();
        _cacheTimer?.cancel();

        _cacheTimer = Timer(Duration(milliseconds: _cacheTime), () {
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

        _cacheTimer = Timer(Duration(milliseconds: _cacheTime), () {
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
  void runOnDispose() {
    _keepAliveLinks?.clear();
    super.runOnDispose();
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
