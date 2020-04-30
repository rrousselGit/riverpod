import 'framework/framework.dart';

class Combiner<Res, _Provider> {
  Combiner1<A, Res, _Provider> add<A extends BaseProviderValue>(
      BaseProvider<A, Object> first) {
    return Combiner1._(first);
  }
}

class Combiner1<A extends BaseProviderValue, Res, _Provider> {
  Combiner1._(this.first);

  final BaseProvider<A, Object> first;

  Combiner2<A, B, Res, _Provider> add<B extends BaseProviderValue>(
      BaseProvider<B, Object> second) {
    return Combiner2._(first, second);
  }
}

class Combiner2<A extends BaseProviderValue, B extends BaseProviderValue, Res,
    _Provider> {
  Combiner2._(this.first, this.second);

  final BaseProvider<A, Object> first;
  final BaseProvider<B, Object> second;

  Combiner3<A, B, C, Res, _Provider> add<C extends BaseProviderValue>(
      BaseProvider<C, Object> third) {
    return Combiner3._(first, second, third);
  }
}

class Combiner3<A extends BaseProviderValue, B extends BaseProviderValue,
    C extends BaseProviderValue, Res, _Provider> {
  Combiner3._(
    this.first,
    this.second,
    this.third,
  );

  final BaseProvider<A, Object> first;
  final BaseProvider<B, Object> second;
  final BaseProvider<C, Object> third;

  Combiner4<A, B, C, D, Res, _Provider> add<D extends BaseProviderValue>(
      BaseProvider<D, Object> forth) {
    return Combiner4._(first, second, third, forth);
  }
}

class Combiner4<A extends BaseProviderValue, B extends BaseProviderValue,
    C extends BaseProviderValue, D extends BaseProviderValue, Res, _Provider> {
  Combiner4._(
    this.first,
    this.second,
    this.third,
    this.forth,
  );

  final BaseProvider<A, Object> first;
  final BaseProvider<B, Object> second;
  final BaseProvider<C, Object> third;
  final BaseProvider<D, Object> forth;

  Combiner5<A, B, C, D, E, Res, _Provider> add<E extends BaseProviderValue>(
      BaseProvider<E, Object> fifth) {
    return Combiner5._(first, second, third, forth, fifth);
  }
}

class Combiner5<
    A extends BaseProviderValue,
    B extends BaseProviderValue,
    C extends BaseProviderValue,
    D extends BaseProviderValue,
    E extends BaseProviderValue,
    Res,
    _Provider> {
  Combiner5._(
    this.first,
    this.second,
    this.third,
    this.forth,
    this.fifth,
  );

  final BaseProvider<A, Object> first;
  final BaseProvider<B, Object> second;
  final BaseProvider<C, Object> third;
  final BaseProvider<D, Object> forth;
  final BaseProvider<E, Object> fifth;

  Combiner6<A, B, C, D, E, F, Res, _Provider> add<F extends BaseProviderValue>(
      BaseProvider<F, Object> sixth) {
    return Combiner6._(first, second, third, forth, fifth, sixth);
  }
}

class Combiner6<
    A extends BaseProviderValue,
    B extends BaseProviderValue,
    C extends BaseProviderValue,
    D extends BaseProviderValue,
    E extends BaseProviderValue,
    F extends BaseProviderValue,
    Res,
    _Provider> {
  Combiner6._(
    this.first,
    this.second,
    this.third,
    this.forth,
    this.fifth,
    this.sixth,
  );

  final BaseProvider<A, Object> first;
  final BaseProvider<B, Object> second;
  final BaseProvider<C, Object> third;
  final BaseProvider<D, Object> forth;
  final BaseProvider<E, Object> fifth;
  final BaseProvider<F, Object> sixth;

  Combiner7<A, B, C, D, E, F, G, Res, _Provider> add<G extends BaseProviderValue>(
    BaseProvider<G, Object> seventh,
  ) {
    return Combiner7._(first, second, third, forth, fifth, sixth, seventh);
  }
}

class Combiner7<
    A extends BaseProviderValue,
    B extends BaseProviderValue,
    C extends BaseProviderValue,
    D extends BaseProviderValue,
    E extends BaseProviderValue,
    F extends BaseProviderValue,
    G extends BaseProviderValue,
    Res,
    _Provider> {
  Combiner7._(
    this.first,
    this.second,
    this.third,
    this.forth,
    this.fifth,
    this.sixth,
    this.seventh,
  );

  final BaseProvider<A, Object> first;
  final BaseProvider<B, Object> second;
  final BaseProvider<C, Object> third;
  final BaseProvider<D, Object> forth;
  final BaseProvider<E, Object> fifth;
  final BaseProvider<F, Object> sixth;
  final BaseProvider<G, Object> seventh;

  Combiner8<A, B, C, D, E, F, G, H, Res, _Provider>
      add<H extends BaseProviderValue>(
    BaseProvider<H, Object> eighth,
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

class Combiner8<
    A extends BaseProviderValue,
    B extends BaseProviderValue,
    C extends BaseProviderValue,
    D extends BaseProviderValue,
    E extends BaseProviderValue,
    F extends BaseProviderValue,
    G extends BaseProviderValue,
    H extends BaseProviderValue,
    Res,
    _Provider> {
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

  final BaseProvider<A, Object> first;
  final BaseProvider<B, Object> second;
  final BaseProvider<C, Object> third;
  final BaseProvider<D, Object> forth;
  final BaseProvider<E, Object> fifth;
  final BaseProvider<F, Object> sixth;
  final BaseProvider<G, Object> seventh;
  final BaseProvider<H, Object> eighth;
}
