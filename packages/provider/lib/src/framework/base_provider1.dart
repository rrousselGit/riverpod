part of 'framework.dart';

// BaseProvider1

abstract class BaseProvider1<
    First extends ProviderState,
    CombiningValue extends ProviderState,
    ListenedValue> extends BaseProvider<CombiningValue, ListenedValue> {
  BaseProvider1(this._first);

  final BaseProvider<First, Object> _first;

  @override
  Iterable<BaseProvider<ProviderState, Object>> _allDependencies() sync* {
    yield _first;
  }

  @override
  BaseProvider1State<First, CombiningValue, ListenedValue,
      BaseProvider1<First, CombiningValue, ListenedValue>> createState();
}

abstract class BaseProvider1State<
        First extends ProviderState,
        CombiningValue extends ProviderState,
        ListenedValue,
        T extends BaseProvider1<First, CombiningValue, ListenedValue>>
    extends BaseProviderState<CombiningValue, ListenedValue, T> {
  First _firstDependencyState;
  First get firstDependencyState {
    return _firstDependencyState;
  }

  @override
  void _initDependencies(
    List<
            BaseProviderState<ProviderState, Object,
                BaseProvider<ProviderState, Object>>>
        dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState = dependenciesState.first.createProviderState() as First;
  }
}

// BaseProvider2

abstract class BaseProvider2<
    First extends ProviderState,
    Second extends ProviderState,
    CombiningValue extends ProviderState,
    ListenedValue> extends BaseProvider<CombiningValue, ListenedValue> {
  BaseProvider2(this._first, this._second);

  final BaseProvider<First, Object> _first;
  final BaseProvider<Second, Object> _second;

  @override
  Iterable<BaseProvider<ProviderState, Object>> _allDependencies() sync* {
    yield _first;
    yield _second;
  }

  @override
  BaseProvider2State<First, Second, CombiningValue, ListenedValue,
          BaseProvider2<First, Second, CombiningValue, ListenedValue>>
      createState();
}

abstract class BaseProvider2State<
        First extends ProviderState,
        Second extends ProviderState,
        CombiningValue extends ProviderState,
        ListenedValue,
        T extends BaseProvider2<First, Second, CombiningValue, ListenedValue>>
    extends BaseProviderState<CombiningValue, ListenedValue, T> {
  First _firstDependencyState;
  First get firstDependencyState {
    return _firstDependencyState;
  }

  Second _secondDependencyState;
  Second get secondDependencyState {
    return _secondDependencyState;
  }

  @override
  void _initDependencies(
    List<
            BaseProviderState<ProviderState, Object,
                BaseProvider<ProviderState, Object>>>
        dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState = dependenciesState.first.createProviderState() as First;
    _secondDependencyState = dependenciesState[1].createProviderState() as Second;
  }
}
