part of '../notifier.dart';

abstract class Notifier<State> extends NotifierBase<State> {
  late final NotifierProviderElement<Notifier<State>, State> _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element = element as NotifierProviderElement<Notifier<State>, State>;
  }

  @override
  NotifierProviderRef<State> get ref => _element;

  @protected
  @override
  State get state {
    // TODO test flush
    _element.flush();
    // ignore: invalid_use_of_protected_member
    return _element.requireState;
  }

  @override
  set state(State value) {
    // ignore: invalid_use_of_protected_member
    _element.setState(value);
  }
}

/// {@macro riverpod.providerrefbase}
abstract class NotifierProviderRef<T> implements Ref<T> {}

/// {@template riverpod.notifier}
/// {@endtemplate}
class NotifierProvider<NotifierT extends NotifierBase<T>, T>
    extends _NotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.notifier}
  NotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  // /// {@macro riverpod.autoDispose}
  // static const autoDispose = AutoDisposeNotifierProviderBuilder();

  // /// {@macro riverpod.family}
  // static const family = NotifierProviderFamilyBuilder();

  @override
  NotifierProviderElement<NotifierT, T> createElement() {
    return NotifierProviderElement._(this);
  }

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);
}

/// The element of [NotifierProvider].
class NotifierProviderElement<NotifierT extends NotifierBase<T>, T>
    extends ProviderElementBase<T> implements NotifierProviderRef<T> {
  NotifierProviderElement._(_NotifierProviderBase<NotifierT, T> provider)
      : super(provider);

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _NotifierProviderBase<NotifierT, T>;

    final notifierResult = _notifierNotifier.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

// TODO test if Element fails to init, the provider rethrows the error
    final notifier = notifierResult.requireState;

// TODO test if Element fails to init, the provider rethrows the error
    setState(notifier.build());
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
