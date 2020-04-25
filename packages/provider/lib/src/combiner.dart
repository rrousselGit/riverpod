import 'framework/framework.dart';

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

  Combiner3<A, B, C, Res, _Provider> add<C>(BaseProvider<C> third) {
    return Combiner3._(first, second, third);
  }
}

class Combiner3<A, B, C, Res, _Provider> {
  Combiner3._(
    this.first,
    this.second,
    this.third,
  );

  final BaseProvider<A> first;
  final BaseProvider<B> second;
  final BaseProvider<C> third;

  Combiner4<A, B, C, D, Res, _Provider> add<D>(BaseProvider<D> forth) {
    return Combiner4._(first, second, third, forth);
  }
}

class Combiner4<A, B, C, D, Res, _Provider> {
  Combiner4._(
    this.first,
    this.second,
    this.third,
    this.forth,
  );

  final BaseProvider<A> first;
  final BaseProvider<B> second;
  final BaseProvider<C> third;
  final BaseProvider<D> forth;

  Combiner5<A, B, C, D, E, Res, _Provider> add<E>(BaseProvider<E> fifth) {
    return Combiner5._(first, second, third, forth, fifth);
  }
}

class Combiner5<A, B, C, D, E, Res, _Provider> {
  Combiner5._(
    this.first,
    this.second,
    this.third,
    this.forth,
    this.fifth,
  );

  final BaseProvider<A> first;
  final BaseProvider<B> second;
  final BaseProvider<C> third;
  final BaseProvider<D> forth;
  final BaseProvider<E> fifth;

  Combiner6<A, B, C, D, E, F, Res, _Provider> add<F>(BaseProvider<F> sixth) {
    return Combiner6._(first, second, third, forth, fifth, sixth);
  }
}

class Combiner6<A, B, C, D, E, F, Res, _Provider> {
  Combiner6._(
    this.first,
    this.second,
    this.third,
    this.forth,
    this.fifth,
    this.sixth,
  );

  final BaseProvider<A> first;
  final BaseProvider<B> second;
  final BaseProvider<C> third;
  final BaseProvider<D> forth;
  final BaseProvider<E> fifth;
  final BaseProvider<F> sixth;

  Combiner7<A, B, C, D, E, F, G, Res, _Provider> add<G>(
    BaseProvider<G> seventh,
  ) {
    return Combiner7._(first, second, third, forth, fifth, sixth, seventh);
  }
}

class Combiner7<A, B, C, D, E, F, G, Res, _Provider> {
  Combiner7._(
    this.first,
    this.second,
    this.third,
    this.forth,
    this.fifth,
    this.sixth,
    this.seventh,
  );

  final BaseProvider<A> first;
  final BaseProvider<B> second;
  final BaseProvider<C> third;
  final BaseProvider<D> forth;
  final BaseProvider<E> fifth;
  final BaseProvider<F> sixth;
  final BaseProvider<G> seventh;

  Combiner8<A, B, C, D, E, F, G, H, Res, _Provider> add<H>(
    BaseProvider<H> eighth,
  ) {
    return Combiner8._(
      first,
      second,
      third,
      forth,
      fifth,
      sixth,
      seventh,
      eighth,
    );
  }
}

class Combiner8<A, B, C, D, E, F, G, H, Res, _Provider> {
  Combiner8._(
    this.first,
    this.second,
    this.third,
    this.forth,
    this.fifth,
    this.sixth,
    this.seventh,
    this.eighth,
  );

  final BaseProvider<A> first;
  final BaseProvider<B> second;
  final BaseProvider<C> third;
  final BaseProvider<D> forth;
  final BaseProvider<E> fifth;
  final BaseProvider<F> sixth;
  final BaseProvider<G> seventh;
  final BaseProvider<H> eighth;
}
