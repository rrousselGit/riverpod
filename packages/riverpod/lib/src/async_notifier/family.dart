part of '../async_notifier.dart';

/// {@macro riverpod.asyncnotifier}
abstract class FamilyAsyncNotifier<State, Arg>
    extends AsyncNotifierBase<State> {
  /// {@template riverpod.notifier.family_arg}
  /// The argument that was passed to this family.
  ///
  /// For example, when doing:
  ///
  /// ```dart
  /// ref.watch(provider(0));
  /// ```
  ///
  /// then [arg] will be `0`.
  /// {@endtemplate}
  late final Arg arg;

  @override
  late final AsyncNotifierProviderElement<FamilyAsyncNotifier<State, Arg>,
      State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element
        as AsyncNotifierProviderElement<FamilyAsyncNotifier<State, Arg>, State>;
    arg = element.origin.argument as Arg;
  }

  @override
  AsyncNotifierProviderRef<State> get ref => _element;

  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

/// {@template riverpod.async_notifier_family_provider}
/// The provider for [AsyncNotifierProviderFamily].
/// {@endtemplate}
typedef AsyncNotifierFamilyProvider<
        NotifierT extends FamilyAsyncNotifier<T, Arg>, T, Arg>
    = TestFamilyAsyncNotifierProvider<NotifierT, T, Arg>;

/// An internal implementation of [AsyncNotifierFamilyProvider] for testing purpose.
///
/// Not meant for public consumption.
@visibleForTesting
@internal
class TestFamilyAsyncNotifierProvider<NotifierT extends AsyncNotifierBase<T>, T,
        Arg> extends AsyncNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.async_notifier_family_provider}
  TestFamilyAsyncNotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeAsyncNotifierProviderFamily.new;

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
    covariant FamilyAsyncNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [AsyncNotifierProvider].
class AsyncNotifierProviderFamily<NotifierT extends FamilyAsyncNotifier<T, Arg>,
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
