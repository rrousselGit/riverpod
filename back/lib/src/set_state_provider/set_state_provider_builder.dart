part of 'set_state_provider.dart';

mixin _Noop {}

/// A variant of [ProviderBuilder] for [SetStateProvider].
class SetStateProviderBuilder<Res> = Combiner<Res, SetStateProvider> with _Noop;

/// An implementation detail of [SetStateProviderBuilder].
extension SetStateProviderBuilder1X<A, Res>
    on Combiner1<A, Res, SetStateProvider> {
  SetStateProvider1<A, Res> build(Create1<A, Res, ProviderState> cb) {
    return SetStateProvider1(first, cb);
  }
}
