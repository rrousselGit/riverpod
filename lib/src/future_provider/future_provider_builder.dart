part of 'future_provider.dart';

mixin _Noop {}

/// A variant of [ProviderBuilder] for [FutureProvider].
class FutureProviderBuilder<Res> = Combiner<Res, FutureProvider> with _Noop;

/// An implementation detail of [FutureProviderBuilder].
extension FutureProviderBuilder1X<A, Res> on Combiner1<A, Res, FutureProvider> {
  // FutureProvider1<A, Res> build(Create1<A, Res, ProviderState> cb) {
  //   return FutureProvider1(first, cb);
  // }
}
