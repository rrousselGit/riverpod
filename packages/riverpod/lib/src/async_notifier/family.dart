part of '../async_notifier.dart';

abstract class AsyncNotifierFamily<State, Arg>
    extends AsyncNotifierBase<State> {
  late final Arg arg;

  late final AsyncNotifierProviderElement<AsyncNotifierFamily<State, Arg>,
      State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element
        as AsyncNotifierProviderElement<AsyncNotifierFamily<State, Arg>, State>;
    arg = element.origin.argument as Arg;
  }

  @override
  AsyncNotifierProviderRef<State> get ref => _element;

  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

/// The provider for [AsyncNotifierProviderFamily].
typedef AsyncNotifierFamilyProvider<
        NotifierT extends AsyncNotifierFamily<T, Arg>, T, Arg>
    = TestAsyncNotifierFamilyProvider<NotifierT, T, Arg>;

@visibleForTesting
class TestAsyncNotifierFamilyProvider<NotifierT extends AsyncNotifierBase<T>, T,
        Arg> extends AsyncNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.notifier}
  TestAsyncNotifierFamilyProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  /// {@macro riverpod.autoDispose}
  // ignore: prefer_const_declarations
  static final autoDispose = AutoDisposeAsyncNotifierProviderFamily.new;

  // /// {@macro riverpod.family}
  // static const family = AsyncNotifierProviderFamilyBuilder();

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _future<T>(this);

  @override
  AsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AsyncNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> _runNotifierBuild(
    covariant AsyncNotifierFamily<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [AsyncNotifierProvider].
class AsyncNotifierProviderFamily<NotifierT extends AsyncNotifierFamily<T, Arg>,
        T, Arg>
    extends NotifierFamilyBase<AsyncNotifierProviderRef<T>, AsyncValue<T>, Arg,
        NotifierT, AsyncNotifierFamilyProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AsyncNotifierProvider].
  AsyncNotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AsyncNotifierFamilyProvider.new);
}
