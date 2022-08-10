part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeStateNotifierProviderRef<
        NotifierT extends StateNotifier<T>,
        T> extends StateNotifierProviderRef<NotifierT, T>
    implements AutoDisposeRef<T> {}

class AutoDisposeStateNotifierProvider<NotifierT extends StateNotifier<T>, T>
    extends _StateNotifierProviderBase<NotifierT, T> {
  AutoDisposeStateNotifierProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  });

  static const family = AutoDisposeStateNotifierProviderFamily.new;

  final NotifierT Function(
      AutoDisposeStateNotifierProviderRef<NotifierT, T> ref) _createFn;

  @override
  NotifierT _create(AutoDisposeStateNotifierProviderElement<NotifierT, T> ref) {
    return _createFn(ref);
  }

  @override
  AutoDisposeStateNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeStateNotifierProviderElement(this);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier(this);
}

class AutoDisposeStateNotifierProviderElement<
        NotifierT extends StateNotifier<T>,
        T> = StateNotifierProviderElement<NotifierT, T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeStateNotifierProviderRef<NotifierT, T>;

class AutoDisposeStateNotifierProviderFamily<NotifierT extends StateNotifier<T>,
        T, Arg>
    extends AutoDisposeFamilyBase<
        AutoDisposeStateNotifierProviderRef<NotifierT, T>,
        T,
        Arg,
        NotifierT,
        AutoDisposeStateNotifierProvider<NotifierT, T>> {
  AutoDisposeStateNotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: AutoDisposeStateNotifierProvider.new);
}
