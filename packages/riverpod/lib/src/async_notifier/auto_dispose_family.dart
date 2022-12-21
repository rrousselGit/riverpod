part of '../async_notifier.dart';

/// {@macro riverpod.asyncnotifier}
abstract class AutoDisposeFamilyAsyncNotifier<State, Arg>
    extends BuildlessAutoDisposeAsyncNotifier<State> {
  /// {@template riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    super._setElement(element);
    arg = element.origin.argument as Arg;
  }

  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

/// {@macro riverpod.asyncnotifier}
typedef AutoDisposeFamilyAsyncNotifierProvider<
        NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>
    = AutoDisposeFamilyAsyncNotifierProviderImpl<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeAsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AsyncNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeAsyncNotifierProvider] and
/// [AsyncNotifierProvider] at the same time.
@internal
class AutoDisposeFamilyAsyncNotifierProviderImpl<
    NotifierT extends AsyncNotifierBase<T>,
    T,
    Arg> extends AsyncNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.notifier}
  AutoDisposeFamilyAsyncNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
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
  }) : super(providerFactory: AutoDisposeFamilyAsyncNotifierProvider.new);

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<AsyncValue<T>, Arg,
        AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>>(
      this,
      (arg) => AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>(
        create,
        from: from,
        argument: arg,
      ),
    );
  }
}
