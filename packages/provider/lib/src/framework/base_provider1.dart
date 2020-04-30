part of 'framework.dart';

// BaseProvider1

abstract class BaseProvider1<
    First extends BaseProviderValue,
    CombiningValue extends BaseProviderValue,
    ListenedValue> extends BaseProvider<CombiningValue, ListenedValue> {
  BaseProvider1(this._first);

  final BaseProvider<First, Object> _first;

  @override
  Iterable<BaseProvider<BaseProviderValue, Object>> _allDependencies() sync* {
    yield _first;
  }

  @override
  BaseProvider1State<First, CombiningValue, ListenedValue,
      BaseProvider1<First, CombiningValue, ListenedValue>> createState();
}

abstract class BaseProvider1State<
        First extends BaseProviderValue,
        CombiningValue extends BaseProviderValue,
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
            BaseProviderState<BaseProviderValue, Object,
                BaseProvider<BaseProviderValue, Object>>>
        dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState =
        dependenciesState.first.createProviderState() as First;
  }

  @override
  void dispose() {
    _firstDependencyState.dispose();
    // TODO test
    super.dispose();
  }
}

// BaseProvider2

abstract class BaseProvider2<
    First extends BaseProviderValue,
    Second extends BaseProviderValue,
    CombiningValue extends BaseProviderValue,
    ListenedValue> extends BaseProvider<CombiningValue, ListenedValue> {
  BaseProvider2(this._first, this._second);

  final BaseProvider<First, Object> _first;
  final BaseProvider<Second, Object> _second;

  @override
  Iterable<BaseProvider<BaseProviderValue, Object>> _allDependencies() sync* {
    yield _first;
    yield _second;
  }

  @override
  BaseProvider2State<First, Second, CombiningValue, ListenedValue,
          BaseProvider2<First, Second, CombiningValue, ListenedValue>>
      createState();
}

abstract class BaseProvider2State<
        First extends BaseProviderValue,
        Second extends BaseProviderValue,
        CombiningValue extends BaseProviderValue,
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
            BaseProviderState<BaseProviderValue, Object,
                BaseProvider<BaseProviderValue, Object>>>
        dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _firstDependencyState =
        dependenciesState.first.createProviderState() as First;
    _secondDependencyState =
        dependenciesState[1].createProviderState() as Second;
  }

  @override
  void dispose() {
    _firstDependencyState.dispose();
    _secondDependencyState.dispose();
    // TODO test
    super.dispose();
  }
}
