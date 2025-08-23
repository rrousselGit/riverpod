part of '../matrix.dart';

final streamNotifierProviderFactory = TestMatrix<StreamNotifierTestFactory>(
  {
    'StreamNotifierProvider': StreamNotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
      deferredNotifier: DeferredStreamNotifier.new,
      deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
        return StreamNotifierProvider<DeferredStreamNotifier<ValueT>, ValueT>(
          retry: retry,
          () => DeferredStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <ValueT>(create) =>
          StreamNotifierProvider<StreamNotifier<ValueT>, ValueT>(
        () => create() as StreamNotifier<ValueT>,
      ),
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider<StreamNotifier<Object?>, Object?>(
          () => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'StreamNotifierProvider.autoDispose': StreamNotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
      deferredNotifier: DeferredStreamNotifier.new,
      deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
        return StreamNotifierProvider.autoDispose<
            DeferredStreamNotifier<ValueT>, ValueT>(
          retry: retry,
          () => DeferredStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <ValueT>(create) {
        return StreamNotifierProvider.autoDispose<StreamNotifier<ValueT>,
            ValueT>(
          () => create() as StreamNotifier<ValueT>,
        );
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider.autoDispose<StreamNotifier<Object?>,
            Object?>(
          retry: retry,
          () => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'StreamNotifierProvider.family': StreamNotifierTestFactory(
      isAutoDispose: false,
      isFamily: true,
      deferredNotifier: DeferredStreamNotifier.new,
      deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
        return StreamNotifierProvider.family<DeferredStreamNotifier<ValueT>,
            ValueT, Object?>(
          retry: retry,
          (arg) => DeferredStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        ).call(42);
      },
      provider: <ValueT>(create) {
        return StreamNotifierProvider.family<StreamNotifier<ValueT>, ValueT,
            Object?>(
          (arg) => create() as StreamNotifier<ValueT>,
        ).call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider.family<StreamNotifier<Object?>, Object?,
            Object?>(
          retry: retry,
          (arg) => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
    'StreamNotifierProvider.autoDispose.family': StreamNotifierTestFactory(
      isAutoDispose: true,
      isFamily: true,
      deferredNotifier: DeferredStreamNotifier.new,
      deferredProvider: <ValueT>(create, {updateShouldNotify, retry}) {
        return StreamNotifierProvider.family
            .autoDispose<DeferredStreamNotifier<ValueT>, ValueT, Object?>(
              retry: retry,
              (arg) => DeferredStreamNotifier(
                create,
                updateShouldNotify: updateShouldNotify,
              ),
            )
            .call(42);
      },
      provider: <ValueT>(create) {
        return StreamNotifierProvider.autoDispose
            .family<StreamNotifier<ValueT>, ValueT, Object?>(
              (arg) => create() as StreamNotifier<ValueT>,
            )
            .call(42);
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return StreamNotifierProvider.autoDispose
            .family<StreamNotifier<Object?>, Object?, Object?>(
          retry: retry,
          (arg) => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
  },
);

abstract class TestStreamNotifier<ValueT> implements $StreamNotifier<ValueT> {}

class DeferredStreamNotifier<ValueT> extends StreamNotifier<ValueT>
    implements TestStreamNotifier<ValueT> {
  DeferredStreamNotifier(
    this._create, {
    bool Function(AsyncValue<ValueT>, AsyncValue<ValueT>)? updateShouldNotify,
    this.arg,
  }) : _updateShouldNotify = updateShouldNotify;

  final Object? arg;

  final Stream<ValueT> Function(
    Ref ref,
    DeferredStreamNotifier<ValueT> self,
  ) _create;
  final bool Function(
    AsyncValue<ValueT> previousState,
    AsyncValue<ValueT> newState,
  )? _updateShouldNotify;

  @override
  Stream<ValueT> build() => _create(ref, this);

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

class StreamNotifierTestFactory extends TestFactory<
    ProviderFactory<$StreamNotifier<Object?>, ProviderBase<Object?>>> {
  StreamNotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestStreamNotifier<ValueT> Function<ValueT>(
    Stream<ValueT> Function(Ref ref, $StreamNotifier<ValueT> self) create,
  ) deferredNotifier;

  final $StreamNotifierProvider<TestStreamNotifier<ValueT>, ValueT>
      Function<ValueT>(
    Stream<ValueT> Function(Ref ref, $StreamNotifier<ValueT> self) create, {
    bool Function(AsyncValue<ValueT>, AsyncValue<ValueT>)? updateShouldNotify,
    Retry? retry,
  }) deferredProvider;

  final $StreamNotifierProvider<$StreamNotifier<ValueT>, ValueT>
      Function<ValueT>(
    $StreamNotifier<ValueT> Function() create,
  ) provider;

  $StreamNotifierProvider<TestStreamNotifier<ValueT>, ValueT>
      simpleTestProvider<ValueT>(
    Stream<ValueT> Function(Ref ref, $StreamNotifier<ValueT> self) create, {
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
