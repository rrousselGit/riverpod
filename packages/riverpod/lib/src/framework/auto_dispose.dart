part of '../framework.dart';

/// A [ProviderReference] for providers that are automatically destroyed when
/// no-longer used.
///
/// The difference with [ProviderReference] is that it has an extra
/// [maintainState] property, to help determine if the state can be destroyed
///  or not.
abstract class AutoDisposeProviderReference extends ProviderReference {
  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `false`,
  /// may destroy the provider state if it currently has no listeners.
  ///
  /// Defaults to `false`.
  bool get maintainState;
  set maintainState(bool value);

  @override
  T watch<T>(RootProvider<Object?, T> provider);

  @override
  void Function() listen<T>(
    // Overriden to allow AutoDisposeProviderBase
    ProviderBase<Object?, T> provider,
    void Function(T value) listener, {
    bool fireImmediately,
  });
}

/// {@template riverpod.AutoDisposeProviderBase}
/// A base class for providers that destroy their state when no-longer listened.
///
/// See also:
///
/// - [Provider.autoDispose], a variant of [Provider] that auto-dispose its state.
/// {@endtemplate}
abstract class AutoDisposeProviderBase<Created, Listened>
    extends RootProvider<Created, Listened> {
  /// {@macro riverpod.AutoDisposeProviderBase}
  AutoDisposeProviderBase(String? name) : super(name);

  @override
  Created create(covariant AutoDisposeProviderReference ref);

  @override
  AutoDisposeProviderElement<Created, Listened> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

/// The [ProviderElement] of an [AutoDisposeProviderBase].
class AutoDisposeProviderElement<Created, Listened>
    extends ProviderElement<Created, Listened>
    implements AutoDisposeProviderReference {
  /// The [ProviderElement] of an [AutoDisposeProviderBase].
  AutoDisposeProviderElement(
    ProviderBase<Created, Listened> provider,
  ) : super(provider);

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
