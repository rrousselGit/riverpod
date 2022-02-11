part of '../framework.dart';

/// A base class for all providers, used to consume a provider.
///
/// It is used by [ProviderContainer.listen] and `ref.watch` to listen to
/// both a provider and `provider.select`.
///
/// Do not implement or extend.
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
abstract class AlwaysAliveProviderBase<State> extends ProviderBase<State>
    with AlwaysAliveProviderListenable<State> {
  /// Creates an [AlwaysAliveProviderBase].
  AlwaysAliveProviderBase({
    required String? name,
    required Family? from,
    required Object? argument,
  }) : super(name: name, from: from, argument: argument);

  @override
  ProviderElementBase<State> createElement();
}

class _AlwaysAliveProviderSelector<Input, Output> = _ProviderSelector<Input,
    Output> with AlwaysAliveProviderListenable<Output>;
