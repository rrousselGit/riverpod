part of 'set_state_provider.dart';

class SetStateProvider1<A, Res>
    extends BaseProvider1<A, SetStateProviderValue<Res>>
    with _SetStateProviderMixin<Res> {
  SetStateProvider1(BaseProvider<A> first, this._create) : super(first);

  final Create1<A, Res, ProviderState> _create;

  @override
  _SetStateProvider1State<A, Res> createState() {
    return _SetStateProvider1State<A, Res>();
  }
}

class _SetStateProvider1State<A, Res> extends BaseProvider1State<A,
        SetStateProviderValue<Res>, SetStateProvider1<A, Res>>
    with _SetStateProviderStateMixin<Res, SetStateProvider1<A, Res>> {
  @override
  Res create() {
    return provider._create(this, firstDependencyState);
  }
}
