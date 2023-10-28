part of '../framework.dart';

/// A mixin that adds auto dispose support to a [ProviderElementBase].
@internal
mixin AutoDisposeProviderElementMixin<State> on ProviderElementBase<State>
    implements AutoDisposeRef<State> {
  List<KeepAliveLink>? _keepAliveLinks;

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

    if (!hasListeners && (links == null || links.isEmpty)) {
      _container._scheduler.scheduleProviderDispose(this);
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
}

/// A object which maintains a provider alive.
class KeepAliveLink {
  KeepAliveLink._(this._close);

  final void Function() _close;

  /// Release this [KeepAliveLink], allowing the associated provider to
  /// be disposed if the provider is no-longer listener nor has any
  /// remaining [KeepAliveLink].
  void close() => _close();
}
