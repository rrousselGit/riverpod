part of '../framework.dart';

class ObserverContext {
  ObserverContext._({
    required this.provider,
    required this.container,
    required this.mutation,
  });

  final AnyProvider<Object?> provider;
  final ProviderContainer container;
  final Call<Object?>? mutation;
}

mixin ProviderObserver2 implements AnyProviderObserver {
  void didAddProvider(ObserverContext context) {}
  void didInitializeProvider(ObserverContext context, Object? value) {}
  void didPauseProvider(ObserverContext context) {}
  void didResumeProvider(ObserverContext context) {}
  void didCancelProvider(ObserverContext context) {}
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

abstract class Refreshable2<T> implements ProviderListenable<T> {
  /// The provider that is being refreshed.
  ProviderBase2<Object?> get _origin;
}

abstract class Ref2<StateT> {
  ProviderContainer get container;

  @useResult
  T refresh<T>(Refreshable2<T> provider);
  void invalidate(ProviderBase2<Object?> provider);
  void invalidateSelf();

  void notifyListeners();

  KeepAliveLink keepAlive();

  void onAddListener(void Function() cb);
  void onRemoveListener(void Function() cb);
  void onResume(void Function() cb);
  void onCancel(void Function() cb);
  void onDispose(void Function() cb);

  T read<T>(ProviderListenable<T> provider);
  T watch<T>(ProviderListenable<T> provider);
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });
  void listenSelf(
    void Function(StateT previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    void Function(StateT initial) onInit,
  });
}

abstract class SyncRef2<StateT> extends Ref2<StateT> {
  Result<StateT>? get state => throw UnimplementedError();
  Event setData(StateT value) => throw UnimplementedError();
  Event setError(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();
  Never returns(StateT value) => throw UnimplementedError();
}

abstract class AsyncRef2<StateT> extends Ref2<AsyncValue<StateT>> {
  Future<StateT> get future => throw UnimplementedError();
  AsyncValue<StateT> get state => throw UnimplementedError();

  void setLoading() => throw UnimplementedError();
  Event setData(StateT value) => throw UnimplementedError();
  Event setError(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();
  Never emit(Stream<StateT> stream) => throw UnimplementedError();
  Event get wait => throw UnimplementedError();
  Never returns(StateT value) => throw UnimplementedError();
}

final class Event {
  Event._(this._ref);
  // TODO assert when used that it's from the right Ref
  final Ref2<Object?> _ref;
}

abstract class Provider2<StateT> extends ProviderBase2<StateT> {
  factory Provider2._() => throw UnimplementedError();

  @override
  ProviderElementBase<StateT> _createElement() => throw UnimplementedError();

  Event build(SyncRef2<StateT> ref);

  @protected
  Call<R> run<R>(R Function(SyncRef2<StateT> ref) callback) =>
      throw UnimplementedError();
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(SyncRef2<StateT> ref) cb,
  ) =>
      throw UnimplementedError();
}

abstract mixin class AsyncProvider<StateT>
    implements ProviderBase2<AsyncValue<StateT>> {
  factory AsyncProvider(
    FutureOr<StateT> Function(AsyncRef2<StateT> ref) create,
  ) =>
      throw UnimplementedError();

  @override
  ProviderElementBase<AsyncValue<StateT>> _createElement() =>
      throw UnimplementedError();
  @override
  Record? get args => null;

  @override
  ProviderSubscription<AsyncValue<StateT>> _addListener(
    Node node,
    void Function(AsyncValue<StateT>? previous, AsyncValue<StateT> next)
        listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    // TODO: implement _addListener
    throw UnimplementedError();
  }

  @override
  ProviderSubscription<AsyncValue<StateT>> addListener(
    Node node,
    void Function(AsyncValue<StateT>? previous, AsyncValue<StateT> next)
        listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    // TODO: implement addListener
    throw UnimplementedError();
  }

  @override
  Mutation<R> mutation<R>([Symbol? symbol]) {
    // TODO: implement mutation
    throw UnimplementedError();
  }

  ProviderListenable<Future<StateT>> get future => throw UnimplementedError();

  FutureOr<StateT> build(AsyncRef2<StateT> ref);

  @override
  AsyncValue<StateT> read(Node node) {
    return ProviderBase._readImpl(this, node);
  }

  @override
  ProviderListenable<Selected> select<Selected>(
    Selected Function(AsyncValue<StateT> value) selector,
  ) {
    return _ProviderSelector<AsyncValue<StateT>, Selected>(
      provider: this,
      selector: selector,
    );
  }

  @protected
  Call<R> run<R>(R Function(AsyncRef2<StateT> ref) callback) =>
      throw UnimplementedError();
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(AsyncRef2<StateT> ref) cb,
  ) =>
      throw UnimplementedError();

  ProviderListenable<Future<Selected>> selectAsync<Selected>(
    Selected Function(StateT value) selector,
  ) {
    return _AsyncSelector<StateT, Selected>(
      provider: this,
      selector: selector,
      future: future,
    );
  }
}

abstract mixin class SyncProvider<StateT> implements ProviderBase2<StateT> {
  factory SyncProvider(
    FutureOr<StateT> Function(SyncRef2<StateT> ref) create,
  ) =>
      throw UnimplementedError();

  @override
  ProviderElementBase<StateT> _createElement() => throw UnimplementedError();

  @override
  Record? get args => null;

  @override
  ProviderSubscription<StateT> _addListener(
    Node node,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    // TODO: implement _addListener
    throw UnimplementedError();
  }

  @override
  ProviderSubscription<StateT> addListener(
    Node node,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    // TODO: implement addListener
    throw UnimplementedError();
  }

  @override
  ProviderListenable<Selected> select<Selected>(
    Selected Function(StateT value) selector,
  ) {
    return _ProviderSelector<StateT, Selected>(
      provider: this,
      selector: selector,
    );
  }

  @override
  StateT read(Node node) => ProviderBase._readImpl(this, node);

  @override
  Mutation<R> mutation<R>([Symbol? symbol]) {
    // TODO: implement mutation
    throw UnimplementedError();
  }

  StateT build(SyncRef2<StateT> ref);

  @protected
  Call<R> run<R>(R Function(SyncRef2<StateT> ref) callback) =>
      throw UnimplementedError();
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(SyncRef2<StateT> ref) cb,
  ) =>
      throw UnimplementedError();
}

abstract class ProviderBase2<StateT>
    implements
        ProviderListenable<StateT>,
        AnyProvider<StateT>,
        Refreshable2<StateT> {
  ProviderBase2._();

  Record? get args => null;

  @protected
  Mutation<R> mutation<R>([Symbol? symbol]) {
    assert(args == null || symbol != null);
    throw UnimplementedError();
  }

  ProviderElementBase<StateT> _createElement();

  @protected
  Call<R> run<R>(R Function(Ref2<StateT> ref) callback);
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(Ref2<StateT> ref) cb,
  );

  @override
  ProviderSubscription<StateT> _addListener(
    Node node,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    return ProviderBase._addListenerImpl(
      this,
      node,
      listener,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      fireImmediately: fireImmediately,
    );
  }

  @internal
  @override
  ProviderSubscription<StateT> addListener(
    Node node,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    return _addListener(
      node,
      listener,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      fireImmediately: fireImmediately,
    );
  }
}
