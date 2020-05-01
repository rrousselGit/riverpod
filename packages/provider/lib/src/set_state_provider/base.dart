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

class _SetStateProvider<T> extends BaseProvider<SetStateProviderValue<T>, T>
    implements SetStateProvider<T> {
  _SetStateProvider(this._create);

  final Create<T, SetStateProviderState<T>> _create;

  @override
  _SetStateProviderState<T> createState() {
    return _SetStateProviderState<T>();
  }
}

class _SetStateProviderState<T>
    extends BaseProviderState<SetStateProviderValue<T>, T, _SetStateProvider<T>>
    with _SetStateProviderStateMixin<T, _SetStateProvider<T>> {
  @override
  T initState() {
    return provider._create(SetStateProviderState._(this));
  }
}
