part of 'future_provider.dart';

mixin _Noop {}

class FutureProviderBuilder<Res> = Combiner<Res, FutureProvider> with _Noop;

extension FutureProviderBuilder1X<A, Res> on Combiner1<A, Res, FutureProvider> {
  FutureProvider1<A, Res> build(Create1<A, Future<Res>, ProviderState> cb) {
    return FutureProvider1(first, cb);
  }
}
