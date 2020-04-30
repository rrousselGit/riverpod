part of 'provider.dart';

// Provider1

abstract class Provider1<First extends BaseProviderValue, T>
    extends BaseProvider1<First, ProviderValue<T>, T> implements Provider<T> {
  factory Provider1(
    BaseProvider<First, Object> firstProvider,
    Create1<First, T, ProviderState> create,
  ) = _Provider1<First, T>;
}

class _Provider1<First extends BaseProviderValue, T>
    extends BaseProvider1<First, ProviderValue<T>, T>
    with _ProviderMixin<T>
    implements Provider1<First, T> {
  _Provider1(
    BaseProvider<First, Object> firstProvider,
    this.create,
  ) : super(firstProvider);

  final Create1<First, T, ProviderState> create;

  @override
  _Provider1State<First, T> createState() {
    return _Provider1State<First, T>();
  }
}

class _Provider1State<First extends BaseProviderValue, T>
    extends BaseProvider1State<First, ProviderValue<T>, T, _Provider1<First, T>>
    with _ProviderStateMixin<T, _Provider1<First, T>> {
  @override
  T initState() {
    return provider.create(ProviderState(this), firstDependencyState);
  }
}

extension ProviderBuilder1X<First extends BaseProviderValue, T>
    on Combiner1<First, T, Provider> {
  Provider<T> build(Create1<First, T, ProviderState> cb) {
    return Provider1(first, cb);
  }
}

// Provider2

abstract class Provider2<
        First extends BaseProviderValue,
        Second extends BaseProviderValue,
        T> extends BaseProvider2<First, Second, ProviderValue<T>, T>
    implements Provider<T> {
  factory Provider2(
    BaseProvider<First, Object> firstProvider,
    BaseProvider<Second, Object> secondProvider,
    Create2<First, Second, T, ProviderState> create,
  ) = _Provider2<First, Second, T>;
}

class _Provider2<First extends BaseProviderValue, Second extends BaseProviderValue, T>
    extends BaseProvider2<First, Second, ProviderValue<T>, T>
    with _ProviderMixin<T>
    implements Provider2<First, Second, T> {
  _Provider2(
    BaseProvider<First, Object> firstProvider,
    BaseProvider<Second, Object> secondProvider,
    this.create,
  ) : super(firstProvider, secondProvider);

  final Create2<First, Second, T, ProviderState> create;

  @override
  _Provider2State<First, Second, T> createState() {
    return _Provider2State<First, Second, T>();
  }
}

class _Provider2State<First extends BaseProviderValue, Second extends BaseProviderValue,
        T>
    extends BaseProvider2State<First, Second, ProviderValue<T>, T,
        _Provider2<First, Second, T>>
    with _ProviderStateMixin<T, _Provider2<First, Second, T>> {
  @override
  T initState() {
    return provider.create(
      ProviderState(this),
      firstDependencyState,
      secondDependencyState,
    );
  }
}

extension ProviderBuilder2X<First extends BaseProviderValue,
    Second extends BaseProviderValue, T> on Combiner2<First, Second, T, Provider> {
  Provider<T> build(Create2<First, Second, T, ProviderState> cb) {
    return Provider2(first, second, cb);
  }
}
