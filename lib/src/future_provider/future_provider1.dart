part of 'future_provider.dart';

class FutureProvider1<A, Res>
    extends BaseProvider1<A, FutureProviderValue<Res>>
    with _FutureProviderMixin<Res> {
  FutureProvider1(BaseProvider<A> first, this._create) : super(first);

  final Create1<A, Future<Res>, ProviderState> _create;

  @override
  _FutureProvider1State<A, Res> createState() {
    return _FutureProvider1State<A, Res>();
  }
}

class _FutureProvider1State<A, Res> extends BaseProvider1State<A,
        FutureProviderValue<Res>, FutureProvider1<A, Res>>
    with _FutureProviderStateMixin<Res, FutureProvider1<A, Res>> {
  @override
  Future<Res> create() {
    return provider._create(this, firstDependencyState);
  }
}
