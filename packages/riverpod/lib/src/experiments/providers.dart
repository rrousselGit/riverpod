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

abstract class SyncRef<StateT> extends Ref<StateT> {
  StateT? get state => throw UnimplementedError();
  void setData(StateT value) => throw UnimplementedError();
  void setError(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();
  Never returns(StateT value) => throw UnimplementedError();
}

abstract class AsyncRef<StateT> extends Ref<AsyncValue<StateT>> {
  Future<StateT> get future => throw UnimplementedError();
  AsyncValue<StateT> get state => throw UnimplementedError();

  void setLoading() => throw UnimplementedError();
  void setData(StateT value) => throw UnimplementedError();
  void setError(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();
  Never emit(Stream<StateT> stream) => throw UnimplementedError();
  Never returns(StateT value) => throw UnimplementedError();
}

abstract class Provider2<StateT> extends ProviderBase2<StateT> {
  factory Provider2._() => throw UnimplementedError();

  @override
  ProviderElementBase<StateT> _createElement() => throw UnimplementedError();

  @protected
  Call<R> run<R>(R Function(SyncRef<StateT> ref) callback) =>
      throw UnimplementedError();
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(SyncRef<StateT> ref) cb,
  ) =>
      throw UnimplementedError();
}

/// The element of a [FutureProvider]
class _AsyncProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    with
        FutureHandlerProviderElementMixin<T>,
        AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AsyncRef<T> {
  _AsyncProviderElement(AsyncProvider<T> super._provider);

  @override
  Future<T> get future {
    flush();
    return futureNotifier.value;
  }

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as AsyncProvider<T>;

    handleFuture(
      () => provider.build(this),
      didChangeDependency: didChangeDependency,
    );
  }

  @override
  Never emit(Stream<T> stream) {
    // TODO: implement emit
    throw UnimplementedError();
  }

  @override
  Never returns(T value) {
    setData(value);
    throw Exception('ignore');
  }

  @override
  void setData(T value) => setState(AsyncValue.data(value));

  @override
  void setError(Object error, StackTrace stackTrace) =>
      setState(AsyncValue.error(error, stackTrace));

  @override
  void setLoading() => setState(AsyncValue.loading());
}

class _DelegatedAsyncProvider<StateT> with AsyncProvider<StateT> {
  _DelegatedAsyncProvider(this._build);
  final FutureOr<StateT> Function(AsyncRef<StateT> ref) _build;

  @override
  FutureOr<StateT> build(AsyncRef<StateT> ref) => _build(ref);
}

ProviderElementProxy<AsyncValue<T>, Future<T>> _future<T>(
  AsyncProvider<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) {
      return FutureHandlerProviderElementMixin.futureNotifierOf(
        element as FutureHandlerProviderElementMixin<T>,
      );
    },
  );
}

abstract mixin class AsyncProvider<StateT>
    implements ProviderBase2<AsyncValue<StateT>> {
  factory AsyncProvider(
    FutureOr<StateT> Function(AsyncRef<StateT> ref) build,
  ) = _DelegatedAsyncProvider;

  @override
  Record? get args => null;

  late final ProviderListenable<Future<StateT>> future = _future(this);

  FutureOr<StateT> build(AsyncRef<StateT> ref);

  ProviderListenable<Future<Selected>> selectAsync<Selected>(
    Selected Function(StateT value) selector,
  ) {
    return _AsyncSelector<StateT, Selected>(
      provider: this,
      selector: selector,
      future: future,
    );
  }

  @override
  _AsyncProviderElement<StateT> _createElement() => _AsyncProviderElement(this);

  /*
   * Implement mixins
   */

  AnyProvider<Object?> get _origin => this;

  @override
  ProviderSubscription<AsyncValue<StateT>> _addListener(
    Node node,
    void Function(AsyncValue<StateT>? previous, AsyncValue<StateT> next)
        listener, {
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

  @override
  ProviderSubscription<AsyncValue<StateT>> addListener(
    Node node,
    void Function(AsyncValue<StateT>? previous, AsyncValue<StateT> next)
        listener, {
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

  @override
  AsyncValue<StateT> read(Node node) => ProviderBase._readImpl(this, node);

  @override
  Mutation<R> mutation<R>([Symbol? symbol]) => Mutation._(this, symbol);

  @protected
  Call<R> run<R>(R Function(AsyncRef<StateT> ref) callback) =>
      throw UnimplementedError();
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(AsyncRef<StateT> ref) cb,
  ) =>
      throw UnimplementedError();
}

class _DelegatedSyncProvider<StateT> with SyncProvider<StateT> {
  _DelegatedSyncProvider(this._build);
  final StateT Function(SyncRef<StateT> ref) _build;

  @override
  StateT build(SyncRef<StateT> ref) => _build(ref);
}

/// The element of a [FutureProvider]
class _SyncProviderElement<T> extends ProviderElementBase<T>
    with AutoDisposeProviderElementMixin<T>
    implements SyncRef<T> {
  _SyncProviderElement(SyncProvider<T> super._provider);

  @override
  T? get state => throw UnimplementedError();

  @override
  void setData(T value) => setState(value);

  @override
  void setError(Object error, StackTrace stackTrace) =>
      throw UnimplementedError();

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as SyncProvider<T>;

    final value = provider.build(this);
    setState(value);
  }

  @override
  Never returns(T value) {
    setData(value);
    throw Exception('ignore');
  }

  @override
  bool updateShouldNotify(T previous, T next) {
    return previous != next;
  }
}

abstract mixin class SyncProvider<StateT> implements ProviderBase2<StateT> {
  factory SyncProvider(
    StateT Function(SyncRef<StateT> ref) build,
  ) = _DelegatedSyncProvider;

  @override
  Record? get args => null;

  StateT build(SyncRef<StateT> ref);

  @override
  _SyncProviderElement<StateT> _createElement() => _SyncProviderElement(this);

  /*
   * Implement mixins
   */

  AnyProvider<Object?> get _origin => this;

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
  StateT read(Node node) => ProviderBase._readImpl(this, node);

  @override
  Mutation<R> mutation<R>([Symbol? symbol]) => Mutation._(this, symbol);

  @protected
  Call<R> run<R>(R Function(SyncRef<StateT> ref) callback) =>
      throw UnimplementedError();
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(SyncRef<StateT> ref) cb,
  ) =>
      throw UnimplementedError();
}

/// A shared interface by all providers.
///
/// Do not extend or implement this class. Instead use [AsyncProvider]/[SyncProvider].
abstract class ProviderBase2<StateT>
    implements
        ProviderListenable<StateT>,
        AnyProvider<StateT>,
        Refreshable<StateT> {
  ProviderBase2._();

  Record? get args => null;

  @protected
  Mutation<R> mutation<R>([Symbol? symbol]) {
    throw UnimplementedError();
  }

  ProviderElementBase<StateT> _createElement();

  @protected
  Call<R> run<R>(R Function(Ref<StateT> ref) callback);
  @protected
  Call<Future<R>> mutate<R>(
    Mutation<R> key,
    FutureOr<R> Function(Ref<StateT> ref) cb,
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
