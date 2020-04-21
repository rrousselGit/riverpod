import 'framework.dart';

class Combiner<Res, _Provider> {
  Combiner1<A, Res, _Provider> add<A>(BaseProvider<A> first) {
    return Combiner1._(first);
  }
}

class Combiner1<A, Res, _Provider> {
  Combiner1._(this.first);

  final BaseProvider<A> first;

  Combiner2<A, B, Res, _Provider> add<B>(BaseProvider<B> second) {
    return Combiner2._(first, second);
  }
}

class Combiner2<A, B, Res, _Provider> {
  Combiner2._(this.first, this.second);

  final BaseProvider<A> first;
  final BaseProvider<B> second;
}
