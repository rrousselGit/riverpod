part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class StateNotifierProviderRef<NotifierT extends StateNotifier<T>, T>
    implements Ref<T> {
  /// The [StateNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  NotifierT get notifier;
}

class StateNotifierProvider<NotifierT extends StateNotifier<T>, T>
    extends _StateNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<T> {
  StateNotifierProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();
  static const family = StateNotifierProviderFamilyBuilder();

  final NotifierT Function(StateNotifierProviderRef<NotifierT, T> ref)
      _createFn;

  @override
  NotifierT _create(StateNotifierProviderElement<NotifierT, T> ref) {
    return _createFn(ref);
  }

  @override
  StateNotifierProviderElement<NotifierT, T> createElement() {
    return StateNotifierProviderElement._(this);
  }

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier = _notifier(this);
}

class StateNotifierProviderElement<NotifierT extends StateNotifier<T>, T>
    extends ProviderElementBase<T>
    implements StateNotifierProviderRef<NotifierT, T> {
  StateNotifierProviderElement._(
    _StateNotifierProviderBase<NotifierT, T> provider,
  ) : super(provider);

  @override
  NotifierT get notifier => _notifierNotifier.value;
  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

  void Function()? _removeListener;

  @override
  void create() {
    final provider = this.provider as _StateNotifierProviderBase<NotifierT, T>;

    final notifier =
        _notifierNotifier.result = Result.guard(() => provider._create(this));

    _removeListener = notifier
        // TODO test requireState, as ref.read(p) is expected to throw if notifier creation failed
        .requireState
        .addListener(setState, fireImmediately: true);
  }

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    final notifier = _notifierNotifier.result?.stateOrNull;
    if (notifier != null) {
      // TODO test STateNotifier.dispose is guarded
      runGuarded(notifier.dispose);
    }
    _notifierNotifier.result = null;
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_notifierNotifier);
  }
}

class StateNotifierProviderFamily<NotifierT extends StateNotifier<T>, T, Arg>
    extends FamilyBase<StateNotifierProviderRef<NotifierT, T>, T, Arg,
        NotifierT, StateNotifierProvider<NotifierT, T>> {
  StateNotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: StateNotifierProvider.new);
}
