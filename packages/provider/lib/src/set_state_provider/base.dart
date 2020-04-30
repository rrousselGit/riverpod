part of 'set_state_provider.dart';

mixin _SetStateProviderStateMixin<T,
        P extends BaseProvider<SetStateProviderValue<T>, T>>
    on BaseProviderState<SetStateProviderValue<T>, T, P> {
  @override
  // ignore: use_to_and_as_if_applicable, https://github.com/dart-lang/linter/issues/2080
  SetStateProviderValue<T> createProviderState() {
    return SetStateProviderValue._(this);
  }
}

// Provider

class _SetStateProviderState<T>
    extends BaseProviderState<SetStateProviderValue<T>, T, SetStateProvider<T>>
    with _SetStateProviderStateMixin<T, SetStateProvider<T>> {
  @override
  T initState() {
    return provider._create(SetStateProviderState._(this));
  }
}

// Provider1

class _SetStateProvider1<ProviderState1 extends BaseProviderValue, T>
    extends BaseProvider1<ProviderState1, SetStateProviderValue<T>, T> {
  _SetStateProvider1(
    BaseProvider<ProviderState1, Object> provider1,
    this.create,
  ) : super(provider1);

  final Create1<ProviderState1, T, SetStateProviderState<T>> create;

  @override
  _SetStateProviderState1<ProviderState1, T> createState() {
    return _SetStateProviderState1<ProviderState1, T>();
  }
}

class _SetStateProviderState1<ProviderState1 extends BaseProviderValue, T>
    extends BaseProvider1State<ProviderState1, SetStateProviderValue<T>, T,
        _SetStateProvider1<ProviderState1, T>>
    with _SetStateProviderStateMixin<T, _SetStateProvider1<ProviderState1, T>> {
  @override
  T initState() {
    return provider.create(SetStateProviderState._(this), firstDependencyState);
  }
}
