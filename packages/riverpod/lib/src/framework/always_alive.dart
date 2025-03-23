part of '../framework.dart';

/// A base class for all providers, used to consume a provider.
///
/// It is used by [ProviderContainer.listen] and [Ref.watch] to listen to
/// both a provider and `provider.select`.
///
/// Do not implement or extend.
@Deprecated('Will be removed in 3.0.0. Use ProviderListenable instead')
mixin AlwaysAliveProviderListenable<State> on ProviderListenable<State> {
  @override
  AlwaysAliveProviderListenable<Selected> select<Selected>(
    Selected Function(State value) selector,
  ) {
    return _AlwaysAliveProviderSelector<State, Selected>(
      provider: this,
      selector: selector,
    );
  }
}

/// A base class for providers that never dispose themselves.
///
/// This is the default base class for providers, unless a provider was marked
/// with the `.autoDispose` modifier, like: `Provider.autoDispose(...)`
@Deprecated('Will be removed in 3.0.0. Use ProviderBase instead')
mixin AlwaysAliveProviderBase<State> on ProviderBase<State>
    implements
        AlwaysAliveProviderListenable<State>,
        AlwaysAliveRefreshable<State> {
  @override
  AlwaysAliveProviderListenable<Selected> select<Selected>(
    Selected Function(State value) selector,
  ) {
    return _AlwaysAliveProviderSelector<State, Selected>(
      provider: this,
      selector: selector,
    );
  }
}
