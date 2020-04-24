part of 'provider.dart';

mixin _Noop {}

class ProviderBuilder<Res> = Combiner<Res, Provider> with _Noop;

extension ProviderBuilder1X<A, Res> on Combiner1<A, Res, Provider> {
  Provider1<A, Res> build(Create1<A, Res, ProviderState> cb) {
    return Provider1(first, cb);
  }
}
