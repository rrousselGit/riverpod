part of '../framework.dart';

/// A [ProviderRefBase] for providers that are automatically destroyed when
/// no-longer used.
///
/// The difference with [ProviderRefBase] is that it has an extra
/// [maintainState] property, to help determine if the state can be destroyed
///  or not.
abstract class AutoDisposeProviderRefBase extends ProviderRefBase {
  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `false`,
  /// may destroy the provider state if it currently has no listeners.
  ///
  /// Defaults to `false`.
  bool get maintainState;
  set maintainState(bool value);

  @override
  T watch<T>(
    // can watch both auto-dispose and non-auto-dispose providers
    ProviderListenable<T> provider,
  );

  @override
  void Function() listen<T>(
    // Overriden to allow AutoDisposeProviderBase
    ProviderListenable<T> provider,
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
abstract class AutoDisposeProviderBase<State> extends ProviderBase<State> {
  /// {@macro riverpod.AutoDisposeProviderBase}
  AutoDisposeProviderBase(String? name) : super(name);

  @override
  State create(AutoDisposeProviderRefBase ref);

  @override
  AutoDisposeProviderElementBase<State> createElement();
}

/// The [ProviderElementBase] of an [AutoDisposeProviderBase].
abstract class AutoDisposeProviderElementBase<State>
    extends ProviderElementBase<State> implements AutoDisposeProviderRefBase {
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

///
@protected
mixin AutoDisposeProviderOverridesMixin<State>
    on AutoDisposeProviderBase<State> {
  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(State value);

  /// Overrides the behavior of this provider with another provider.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeProviderBase<State> provider,
  );
}
