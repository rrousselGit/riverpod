part of 'provider.dart';

abstract class Provider1<First, Res>
    extends BaseProvider1<First, Immutable<Res>> implements Provider<Res> {
  factory Provider1(
    BaseProvider<First> firstProvider,
    Res Function(ProviderState<Res>, ProviderListenerState<First>) create,
  ) = _Provider1<First, Res>;
}

class _Provider1<First, Res> extends BaseProvider1<First, Immutable<Res>>
    implements Provider1<First, Res> {
  _Provider1(
    BaseProvider<First> firstProvider,
    this.create,
  ) : super(firstProvider);

  final Res Function(ProviderState<Res>, ProviderListenerState<First>) create;

  @override
  _Provider1State<First, Res> createState() {
    return _Provider1State<First, Res>();
  }

  @override
  Res call() {
    return BaseProvider.use(this)._value;
  }
}

class _Provider1State<First, Res>
    extends BaseProvider1State<First, Immutable<Res>, _Provider1<First, Res>>
    implements ProviderState<Res> {
  @override
  Immutable<Res> initState() {
    return Immutable(provider.create(this, firstDependencyState));
  }

  @override
  void onDispose(VoidCallback cb) {
    // TODO: implement onDispose
  }
}
