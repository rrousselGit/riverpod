part of 'framework.dart';

// BaseProvider1

abstract class BaseProvider1<First, CombiningValue, ListenedValue>
    extends BaseProvider<CombiningValue, ListenedValue> {
  BaseProvider1(this._first);

  final BaseProvider<First, Object> _first;

  @override
  Iterable<BaseProvider<Object, Object>> _allDependencies() sync* {
    yield _first;
  }

  @override
  BaseProvider1State<First, CombiningValue, ListenedValue,
      BaseProvider1<First, CombiningValue, ListenedValue>> createState();
}

abstract class BaseProvider1State<First, CombiningValue, ListenedValue,
        T extends BaseProvider1<First, CombiningValue, ListenedValue>>
    extends BaseProviderState<CombiningValue, ListenedValue, T> {
  ProviderListenerState<First> _firstDependencyState;
  ProviderListenerState<First> get firstDependencyState {
    return _firstDependencyState;
  }

  @override
  void _initDependencies(
    List<BaseProviderState<Object, Object, BaseProvider<Object, Object>>>
        dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState =
        dependenciesState.first as ProviderListenerState<First>;
  }
}

// BaseProvider2

abstract class BaseProvider2<First, Second, CombiningValue, ListenedValue>
    extends BaseProvider<CombiningValue, ListenedValue> {
  BaseProvider2(this._first, this._second);

  final BaseProvider<First, Object> _first;
  final BaseProvider<Second, Object> _second;

  @override
  Iterable<BaseProvider<Object, Object>> _allDependencies() sync* {
    yield _first;
    yield _second;
  }

  @override
  BaseProvider2State<First, Second, CombiningValue, ListenedValue,
          BaseProvider2<First, Second, CombiningValue, ListenedValue>>
      createState();
}

abstract class BaseProvider2State<First, Second, CombiningValue, ListenedValue,
        T extends BaseProvider2<First, Second, CombiningValue, ListenedValue>>
    extends BaseProviderState<CombiningValue, ListenedValue, T> {
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
    List<BaseProviderState<Object, Object, BaseProvider<Object, Object>>>
        dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState =
        dependenciesState.first as ProviderListenerState<First>;
    _secondDependencyState =
        dependenciesState[1] as ProviderListenerState<Second>;
  }
}
