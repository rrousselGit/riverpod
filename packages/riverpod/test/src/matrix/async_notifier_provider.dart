part of '../matrix.dart';

final asyncNotifierProviderFactory = TestMatrix<AsyncNotifierTestFactory>({
  'AsyncNotifierProvider': AsyncNotifierTestFactory(
    isAutoDispose: false,
    isFamily: false,
    deferredNotifier: DeferredAsyncNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
      return AsyncNotifierProvider<DeferredAsyncNotifier<ValueT>, ValueT>(
        retry: retry,
        () => DeferredAsyncNotifier(
          create,
          updateShouldNotify: updateShouldNotify,
        ),
      );
    },
    provider:
        <ValueT>(create) =>
            AsyncNotifierProvider<AsyncNotifier<ValueT>, ValueT>(
              () => create() as AsyncNotifier<ValueT>,
            ),
    value:
        (create, {name, dependencies, retry}) => ([arg]) {
          return AsyncNotifierProvider<AsyncNotifier<Object?>, Object?>(
            () => create(null, arg) as AsyncNotifier<Object?>,
            name: name,
            dependencies: dependencies,
            retry: retry,
          );
        },
  ),
  'AsyncNotifierProvider.autoDispose': AsyncNotifierTestFactory(
    isAutoDispose: true,
    isFamily: false,
    deferredNotifier: DeferredAsyncNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
      return AsyncNotifierProvider.autoDispose<
        DeferredAsyncNotifier<ValueT>,
        ValueT
      >(
        retry: retry,
        () => DeferredAsyncNotifier(
          create,
          updateShouldNotify: updateShouldNotify,
        ),
      );
    },
    provider: <ValueT>(create) {
      return AsyncNotifierProvider.autoDispose<AsyncNotifier<ValueT>, ValueT>(
        () => create() as AsyncNotifier<ValueT>,
      );
    },
    value:
        (create, {name, dependencies, retry}) => ([arg]) {
          return AsyncNotifierProvider.autoDispose<
            AsyncNotifier<Object?>,
            Object?
          >(
            () => create(null, arg) as AsyncNotifier<Object?>,
            name: name,
            dependencies: dependencies,
            retry: retry,
          );
        },
  ),
  'AsyncNotifierProvider.family': AsyncNotifierTestFactory(
    isAutoDispose: false,
    isFamily: true,
    deferredNotifier: DeferredAsyncNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
      return AsyncNotifierProvider.family<
        DeferredAsyncNotifier<ValueT>,
        ValueT,
        Object?
      >(
        retry: retry,
        (arg) => DeferredAsyncNotifier(
          create,
          updateShouldNotify: updateShouldNotify,
        ),
      ).call(42);
    },
    provider: <ValueT>(create) {
      return AsyncNotifierProvider.family<
        AsyncNotifier<ValueT>,
        ValueT,
        Object?
      >((arg) => create() as AsyncNotifier<ValueT>).call(42);
    },
    value:
        (create, {name, dependencies, retry}) => ([arg]) {
          return AsyncNotifierProvider.family<
            AsyncNotifier<Object?>,
            Object?,
            Object?
          >(
            (arg) => create(null, arg) as AsyncNotifier<Object?>,
            name: name,
            dependencies: dependencies,
            retry: retry,
          )(arg);
        },
  ),
  'AsyncNotifierProvider.autoDispose.family': AsyncNotifierTestFactory(
    isAutoDispose: true,
    isFamily: true,
    deferredNotifier: DeferredAsyncNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
      return AsyncNotifierProvider.family
          .autoDispose<DeferredAsyncNotifier<ValueT>, ValueT, Object?>(
            retry: retry,
            (arg) => DeferredAsyncNotifier(
              create,
              updateShouldNotify: updateShouldNotify,
            ),
          )
          .call(42);
    },
    provider: <ValueT>(create) {
      return AsyncNotifierProvider.autoDispose
          .family<AsyncNotifier<ValueT>, ValueT, Object?>(
            (arg) => create() as AsyncNotifier<ValueT>,
          )
          .call(42);
    },
    value:
        (create, {name, dependencies, retry}) => ([arg]) {
          return AsyncNotifierProvider.autoDispose
              .family<AsyncNotifier<Object?>, Object?, Object?>(
                (arg) => create(null, arg) as AsyncNotifier<Object?>,
                name: name,
                dependencies: dependencies,
                retry: retry,
              )(arg);
        },
  ),
});

abstract class TestAsyncNotifier<ValueT> implements $AsyncNotifier<ValueT> {}

class DeferredAsyncNotifier<ValueT> extends AsyncNotifier<ValueT>
    implements TestAsyncNotifier<ValueT> {
  DeferredAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<ValueT>, AsyncValue<ValueT>)? updateShouldNotify,
    this.arg,
  }) : _updateShouldNotify = updateShouldNotify;

  final Object? arg;

  final FutureOr<ValueT> Function(Ref ref, DeferredAsyncNotifier<ValueT> self)
  _create;
  final bool Function(
    AsyncValue<ValueT> previousState,
    AsyncValue<ValueT> newState,
  )?
  _updateShouldNotify;

  @override
  FutureOr<ValueT> build() => _create(ref, this);

  @override
  RemoveListener listenSelf(
    void Function(AsyncValue<ValueT>? previous, AsyncValue<ValueT> next)
    listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return super.listenSelf(listener, onError: onError);
  }

  @override
  bool updateShouldNotify(
    AsyncValue<ValueT> previousState,
    AsyncValue<ValueT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class AsyncNotifierTestFactory
    extends
        TestFactory<
          ProviderFactory<$AsyncNotifier<Object?>, ProviderBase<Object?>>
        > {
  AsyncNotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestAsyncNotifier<ValueT> Function<ValueT>(
    FutureOr<ValueT> Function(Ref ref, $AsyncNotifier<ValueT> self) create,
  )
  deferredNotifier;

  final $AsyncNotifierProvider<TestAsyncNotifier<ValueT>, ValueT>
  Function<ValueT>(
    FutureOr<ValueT> Function(Ref ref, $AsyncNotifier<ValueT> self) create, {
    bool Function(AsyncValue<ValueT>, AsyncValue<ValueT>)? updateShouldNotify,
    Retry? retry,
  })
  deferredProvider;

  final $AsyncNotifierProvider<$AsyncNotifier<ValueT>, ValueT> Function<ValueT>(
    $AsyncNotifier<ValueT> Function() create,
  )
  provider;

  $AsyncNotifierProvider<TestAsyncNotifier<ValueT>, ValueT>
  simpleTestProvider<ValueT>(
    FutureOr<ValueT> Function(Ref ref, $AsyncNotifier<ValueT> self) create, {
    bool Function(AsyncValue<ValueT>, AsyncValue<ValueT>)? updateShouldNotify,
    Retry? retry,
  }) {
    return deferredProvider<ValueT>(
      (ref, self) => create(ref, self),
      updateShouldNotify: updateShouldNotify,
      retry: retry,
    );
  }
}
