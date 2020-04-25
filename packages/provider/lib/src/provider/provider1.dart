part of 'provider.dart';

// Provider1

abstract class Provider1<First, Res>
    extends BaseProvider1<First, ProviderValue<Res>> implements Provider<Res> {
  factory Provider1(
    BaseProvider<First> firstProvider,
    Create1<First, Res, ProviderState> create,
  ) = _Provider1<First, Res>;
}

class _Provider1<First, Res> extends BaseProvider1<First, ProviderValue<Res>>
    implements Provider1<First, Res> {
  _Provider1(
    BaseProvider<First> firstProvider,
    this.create,
  ) : super(firstProvider);

  final Create1<First, Res, ProviderState> create;

  @override
  _Provider1State<First, Res> createState() {
    return _Provider1State<First, Res>();
  }
}

class _Provider1State<First, Res> extends BaseProvider1State<First,
    ProviderValue<Res>, _Provider1<First, Res>> {
  @override
  ProviderValue<Res> initState() {
    return ProviderValue(provider.create(this, firstDependencyState));
  }
}

extension ProviderBuilder1X<First, Res> on Combiner1<First, Res, Provider> {
  Provider1<First, Res> build(Create1<First, Res, ProviderState> cb) {
    return Provider1(first, cb);
  }
}

// Provider2

abstract class Provider2<First, Second, Res>
    extends BaseProvider2<First, Second, ProviderValue<Res>>
    implements Provider<Res> {
  factory Provider2(
    BaseProvider<First> firstProvider,
    BaseProvider<Second> secondProvider,
    Create2<First, Second, Res, ProviderState> create,
  ) = _Provider2<First, Second, Res>;
}

class _Provider2<First, Second, Res>
    extends BaseProvider2<First, Second, ProviderValue<Res>>
    implements Provider2<First, Second, Res> {
  _Provider2(
    BaseProvider<First> firstProvider,
    BaseProvider<Second> secondProvider,
    this.create,
  ) : super(firstProvider, secondProvider);

  final Create2<First, Second, Res, ProviderState> create;

  @override
  _Provider2State<First, Second, Res> createState() {
    return _Provider2State<First, Second, Res>();
  }
}

class _Provider2State<First, Second, Res> extends BaseProvider2State<First,
    Second, ProviderValue<Res>, _Provider2<First, Second, Res>> {
  @override
  ProviderValue<Res> initState() {
    return ProviderValue(provider.create(
      this,
      firstDependencyState,
      secondDependencyState,
    ));
  }
}

extension ProviderBuilder2X<First, Second, Res>
    on Combiner2<First, Second, Res, Provider> {
  Provider2<First, Second, Res> build(
      Create2<First, Second, Res, ProviderState> cb) {
    return Provider2(first, second, cb);
  }
}
