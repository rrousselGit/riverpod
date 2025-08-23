part of '../matrix.dart';

final notifierProviderFactory = TestMatrix<NotifierTestFactory>({
  'NotifierProvider': NotifierTestFactory(
    isAutoDispose: false,
    isFamily: false,
    deferredNotifier: DeferredNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify}) {
      return NotifierProvider<DeferredNotifier<ValueT>, ValueT>(
        () => DeferredNotifier(
          (ref, self) => create(ref, self),
          updateShouldNotify: updateShouldNotify,
        ),
      );
    },
    provider: <ValueT>(create) => NotifierProvider<Notifier<ValueT>, ValueT>(
      () => create() as Notifier<ValueT>,
    ),
    value: (create, {name, dependencies, retry}) => ([arg]) {
      return NotifierProvider<Notifier<Object?>, Object?>(
        () => create(null, arg) as Notifier<Object?>,
        name: name,
        dependencies: dependencies,
        retry: retry,
      );
    },
  ),
  'NotifierProvider.autoDispose': NotifierTestFactory(
    isAutoDispose: true,
    isFamily: false,
    deferredNotifier: DeferredNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify}) {
      return NotifierProvider.autoDispose<DeferredNotifier<ValueT>, ValueT>(
        () => DeferredNotifier(
          (ref, self) => create(ref, self),
          updateShouldNotify: updateShouldNotify,
        ),
      );
    },
    provider: <ValueT>(create) {
      return NotifierProvider.autoDispose<Notifier<ValueT>, ValueT>(
        () => create() as Notifier<ValueT>,
      );
    },
    value: (create, {name, dependencies, retry}) => ([arg]) {
      return NotifierProvider.autoDispose<Notifier<Object?>, Object?>(
        () => create(null, arg) as Notifier<Object?>,
        name: name,
        dependencies: dependencies,
        retry: retry,
      );
    },
  ),
  'NotifierProvider.family': NotifierTestFactory(
    isAutoDispose: false,
    isFamily: true,
    deferredNotifier: DeferredNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify}) {
      return NotifierProvider.family<DeferredNotifier<ValueT>, ValueT, Object?>(
        (arg) =>
            DeferredNotifier(create, updateShouldNotify: updateShouldNotify),
      ).call(42);
    },
    provider: <ValueT>(create) {
      return NotifierProvider.family<Notifier<ValueT>, ValueT, Object?>(
        (arg) => create() as Notifier<ValueT>,
      ).call(42);
    },
    value: (create, {name, dependencies, retry}) => ([arg]) {
      return NotifierProvider.family<Notifier<Object?>, Object?, Object?>(
        (arg) => create(null, arg) as Notifier<Object?>,
        name: name,
        dependencies: dependencies,
        retry: retry,
      )(arg);
    },
  ),
  'NotifierProvider.autoDispose.family': NotifierTestFactory(
    isAutoDispose: true,
    isFamily: true,
    deferredNotifier: DeferredNotifier.new,
    deferredProvider: <ValueT>(create, {updateShouldNotify}) {
      return NotifierProvider.family
          .autoDispose<DeferredNotifier<ValueT>, ValueT, Object?>(
            (arg) => DeferredNotifier(
              create,
              updateShouldNotify: updateShouldNotify,
            ),
          )
          .call(42);
    },
    provider: <ValueT>(create) {
      return NotifierProvider.autoDispose
          .family<Notifier<ValueT>, ValueT, Object?>(
            (arg) => create() as Notifier<ValueT>,
          )
          .call(42);
    },
    value: (create, {name, dependencies, retry}) => ([arg]) {
      return NotifierProvider.autoDispose
          .family<Notifier<Object?>, Object?, Object?>(
            (arg) => create(null, arg) as Notifier<Object?>,
            name: name,
            dependencies: dependencies,
            retry: retry,
          )(arg);
    },
  ),
});

abstract class TestNotifier<ValueT> implements $Notifier<ValueT> {
  @override
  RemoveListener listenSelf(
    void Function(ValueT? previous, ValueT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });
}

class DeferredNotifier<ValueT> extends Notifier<ValueT>
    implements TestNotifier<ValueT> {
  DeferredNotifier(
    this._create, {
    bool Function(ValueT, ValueT)? updateShouldNotify,
    this.arg,
  }) : _updateShouldNotify = updateShouldNotify;

  final Object? arg;

  final ValueT Function(Ref ref, DeferredNotifier<ValueT> self) _create;
  final bool Function(ValueT previousState, ValueT newState)?
  _updateShouldNotify;

  @override
  Ref get ref;

  @override
  RemoveListener listenSelf(
    void Function(ValueT? previous, ValueT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });

  @override
  ValueT build() => _create(ref, this);

  @override
  bool updateShouldNotify(ValueT previousState, ValueT newState) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class NotifierTestFactory
    extends
        TestFactory<
          ProviderFactory<$Notifier<Object?>, ProviderBase<Object?>>
        > {
  NotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestNotifier<ValueT> Function<ValueT>(
    ValueT Function(Ref ref, $Notifier<ValueT> self) create,
  )
  deferredNotifier;

  final $NotifierProvider<TestNotifier<ValueT>, ValueT> Function<ValueT>(
    ValueT Function(Ref ref, $Notifier<ValueT> self) create, {
    bool Function(ValueT, ValueT)? updateShouldNotify,
  })
  deferredProvider;

  final $NotifierProvider<$Notifier<ValueT>, ValueT> Function<ValueT>(
    $Notifier<ValueT> Function() create,
  )
  provider;

  $NotifierProvider<TestNotifier<ValueT>, ValueT> simpleTestProvider<ValueT>(
    ValueT Function(Ref ref, $Notifier<ValueT> self) create, {
    bool Function(ValueT, ValueT)? updateShouldNotify,
  }) {
    return deferredProvider<ValueT>(
      (ref, self) => create(ref, self),
      updateShouldNotify: updateShouldNotify,
    );
  }
}
