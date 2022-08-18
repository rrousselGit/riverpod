part of '../async_notifier.dart';

/// {@macro riverpod.asyncnotifier}
abstract class AutoDisposeFamilyAsyncNotifier<State, Arg>
    extends AsyncNotifierBase<State> {
  /// {@template riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  late final AutoDisposeAsyncNotifierProviderElement<
      AutoDisposeFamilyAsyncNotifier<State, Arg>, State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element as AutoDisposeAsyncNotifierProviderElement<
        AutoDisposeFamilyAsyncNotifier<State, Arg>, State>;
    arg = element.origin.argument as Arg;
  }

  @override
  AutoDisposeAsyncNotifierProviderRef<State> get ref => _element;

  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

/// {@macro riverpod.asyncnotifier}
typedef AutoDisposeFamilyAsyncNotifierProvider<
        NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>
    = TestAutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeAsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AsyncNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeAsyncNotifierProvider] and
/// [AsyncNotifierProvider] at the same time.
@internal
class TestAutoDisposeFamilyAsyncNotifierProvider<
    NotifierT extends AsyncNotifierBase<T>,
    T,
    Arg> extends AsyncNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.notifier}
  TestAutoDisposeFamilyAsyncNotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  });

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  late final Refreshable<Future<T>> future = _future<T>(this);

  @override
  AutoDisposeAsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeAsyncNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> runNotifierBuild(
    covariant AutoDisposeFamilyAsyncNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [AsyncNotifierProvider].
class AutoDisposeAsyncNotifierProviderFamily<
        NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>
    extends AutoDisposeNotifierFamilyBase<
        AutoDisposeAsyncNotifierProviderRef<T>,
        AsyncValue<T>,
        Arg,
        NotifierT,
        AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AutoDisposeAsyncNotifierProvider].
  AutoDisposeAsyncNotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: AutoDisposeFamilyAsyncNotifierProvider.new);
}
