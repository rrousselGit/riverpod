part of 'framework.dart';

// BaseProvider1

abstract class BaseProvider1<First, Res> extends BaseProvider<Res> {
  BaseProvider1(this._first);

  final BaseProvider<First> _first;

  @override
  Iterable<BaseProvider<Object>> _allDependencies() sync* {
    yield _first;
  }

  @override
  BaseProvider1State<First, Res, BaseProvider1<First, Res>> createState();
}

abstract class BaseProvider1State<First, Res,
    T extends BaseProvider1<First, Res>> extends BaseProviderState<Res, T> {
  ProviderListenerState<First> _firstDependencyState;
  ProviderListenerState<First> get firstDependencyState {
    return _firstDependencyState;
  }

  @override
  void _initDependencies(
    List<BaseProviderState<Object, BaseProvider<Object>>> dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState =
        dependenciesState.first as ProviderListenerState<First>;
  }
}

// BaseProvider2

abstract class BaseProvider2<First, Second, Res> extends BaseProvider<Res> {
  BaseProvider2(this._first, this._second);

  final BaseProvider<First> _first;
  final BaseProvider<Second> _second;

  @override
  Iterable<BaseProvider<Object>> _allDependencies() sync* {
    yield _first;
    yield _second;
  }

  @override
  BaseProvider2State<First, Second, Res, BaseProvider2<First, Second, Res>>
      createState();
}

abstract class BaseProvider2State<First, Second, Res,
        T extends BaseProvider2<First, Second, Res>>
    extends BaseProviderState<Res, T> {
  ProviderListenerState<First> _firstDependencyState;
  ProviderListenerState<First> get firstDependencyState {
    return _firstDependencyState;
  }

  ProviderListenerState<Second> _secondDependencyState;
  ProviderListenerState<Second> get secondDependencyState {
    return _secondDependencyState;
  }

  @override
  void _initDependencies(
    List<BaseProviderState<Object, BaseProvider<Object>>> dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState =
        dependenciesState.first as ProviderListenerState<First>;
    _secondDependencyState =
        dependenciesState[1] as ProviderListenerState<Second>;
  }
}
