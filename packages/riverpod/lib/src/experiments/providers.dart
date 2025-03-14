part of '../framework.dart';

class ObserverContext {
  ObserverContext._({
    required this.provider,
    required this.container,
    required this.mutation,
  });

  final Provider2<Object?> provider;
  final ProviderContainer container;
  final MutationCall<Object?>? mutation;
}

mixin ProviderObserver2 {
  void didAddProvider(ObserverContext context, Object? value) {}
  void providerDidFail(
    ObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {}
  void didUpdateProvider(
    ObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {}
  void didDisposeProvider(ObserverContext context) {}

  void didStartMutation(ObserverContext context) {}
  void didEndMutation(
    ObserverContext context,
    MutationState<Object?> result,
  ) {}
}

sealed class ProviderListenable2<T>
    implements ProviderListenableOrScope<T>, AnyProviderListenable<T> {
  Result<T> addListener(ProviderListenableTransformer<T> transformer);
}

abstract class Refreshable2<T> implements ProviderListenable2<T> {}

abstract class Ref2<StateT> {
  ProviderContainer get container;

  @useResult
  T refresh<T>(Refreshable2<T> provider);
  void invalidate(Provider2<Object?> provider);
  void invalidateSelf();

  void notifyListeners();

  KeepAliveLink keepAlive();

  void onAddListener(void Function() cb);
  void onRemoveListener(void Function() cb);
  void onResume(void Function() cb);
  void onCancel(void Function() cb);
  void onDispose(void Function() cb);

  T read<T>(ProviderListenable2<T> provider);
  T watch<T>(ProviderListenable2<T> provider);
  ProviderSubscription<T> listen<T>(
    ProviderListenable2<T> provider,
    void Function(T previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });
  void listenSelf(
    void Function(StateT previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    void Function(StateT initial) onInit,
  });
}

extension SyncRefX<StateT> on Ref2<StateT> {
  Result<StateT>? get state => throw UnimplementedError();
  void setData(StateT value) => throw UnimplementedError();
  void setError(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();
}

extension AsyncRefX<StateT> on Ref2<AsyncValue<StateT>> {
  AsyncValue<StateT> get state => throw UnimplementedError();
  Event<StateT> setData(StateT value) => throw UnimplementedError();
  Event<StateT> setError(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();
  Event<StateT> setLoading() => throw UnimplementedError();

  Future<Event<StateT>> emitFuture(Future<StateT> future) =>
      throw UnimplementedError();
  Future<Event<StateT>> emitStream(Stream<StateT> stream) =>
      throw UnimplementedError();
}

class Event<T> {}

extension Ref2X<T> on Ref2<AsyncValue<T>> {
  Future<T> get future => throw UnimplementedError();
}

sealed class Provider2<StateT>
    implements ProviderListenable2<StateT>, AnyProvider<StateT> {
  static Provider2<AsyncValue<T>> async<T>(
    FutureOr<Event<T>> Function(Ref2<AsyncValue<T>> ref) create, {
    GroupBind<T>? group,
  }) =>
      throw UnimplementedError();

  static Provider2<T> sync<T>(
    T Function(Ref2<T> ref) create, {
    GroupBind<T>? group,
  }) =>
      throw UnimplementedError();
}

abstract class CustomProvider2<StateT> implements Provider2<StateT> {
  Record? get args => null;

  @visibleForOverriding
  ProviderHandle<StateT> get create;

  @protected
  ProviderHandle<AsyncValue<T>> async<T>(
    FutureOr<Event<T>> Function(Ref2<AsyncValue<T>> ref) create,
  ) =>
      throw UnimplementedError();

  @protected
  ProviderHandle<T> sync<T>(
    T Function(Ref2<T> ref) create,
  ) =>
      throw UnimplementedError();

  @protected
  Mutation<R> mutation<R>([
    Symbol? symbol,
  ]) {
    assert(args == null || symbol != null);
    throw UnimplementedError();
  }

  @protected
  ProviderCall<R> run<R>(R Function(Ref2<StateT> ref) callback) =>
      throw UnimplementedError();
  @protected
  MutationCall<R> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(Ref2<StateT> ref) cb,
  ) =>
      throw UnimplementedError();

  @override
  Result<StateT> addListener(
    ProviderListenableTransformer<StateT> transformer,
  ) =>
      throw UnimplementedError();
}

abstract class ProviderHandle<StateT> {}

final class ProviderListenableTransformer<T> {
  ProviderListenableTransformer._(this.container);

  final ProviderContainer container;
  void Function(T? previous, T next)? _listener;
  void Function(Object error, StackTrace stackTrace)? _onError;
  Result<T>? get state => _state;
  Result<T>? _state;

  void setState(Result<T> newState) {
    switch (newState) {
      case ResultData<T>():
        _listener?.call(state?.value, newState.value);
        _state = newState;

      case ResultError<T>():
        _onError?.call(newState.error, newState.stackTrace);
        _state = newState;
    }
  }

  ProviderSubscription<T> listen<T>(
    ProviderListenable2<T> listenable,
    void Function(T previous, T next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
  }) =>
      throw UnimplementedError();
}

class _Select<InT, OutT> implements ProviderListenable2<OutT> {
  _Select(this._provider, this._selector);

  final ProviderListenable2<InT> _provider;
  final OutT Function(InT) _selector;

  @override
  Result<OutT> addListener(ProviderListenableTransformer<OutT> transformer) {
    void emit(Result<OutT> value) {
      if (transformer.state != value) transformer.setState(value);
    }

    final sub = transformer.listen<InT>(
      _provider,
      (previous, next) {
        emit(Result.guard(() => _selector(next)));
      },
      onError: (error, stackTrace) {
        emit(Result.error(error, stackTrace));
      },
    );

    return Result.guard(
      () => _selector(sub.read()),
    );
  }
}

extension A<T> on Provider2<AsyncValue<T>> {
  ProviderListenable2<Future<T>> get future => throw UnimplementedError();
}

extension B<T> on ProviderListenableOrScope<T> {
  T watch(Object? ref) => throw UnimplementedError();
}

extension C<T> on ProviderListenableOrScope<AsyncData<T>> {
  T watch(Object? ref) => throw UnimplementedError();
}

extension F on ProviderContainer {
  Result read2<Result>(
    ProviderListenableOrScope<Result> provider,
  ) =>
      throw UnimplementedError();

  /// {@macro riverpod.listen}
  @override
  ProviderSubscription<State> listen2<State>(
    ProviderListenableOrScope<State> provider,
    void Function(State? previous, State next) listener, {
    @Deprecated('Will be removed in 3.0.0') bool fireImmediately = false,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) =>
      throw UnimplementedError();

  T invoke<T>(ProviderCall<T> call) => throw UnimplementedError();
}
