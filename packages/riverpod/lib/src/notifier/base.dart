part of '../notifier.dart';

abstract class Notifier<State> extends NotifierBase<State> {
  late final NotifierProviderElement<Notifier<State>, State> _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element = element as NotifierProviderElement<Notifier<State>, State>;
  }

  @override
  NotifierProviderRef<State> get ref => _element;

  @visibleForOverriding
  State build();
}

/// {@macro riverpod.providerrefbase}
abstract class NotifierProviderRef<T> implements Ref<T> {}

/// {@macro riverpod.notifier}
typedef NotifierProvider<NotifierT extends Notifier<T>, T>
    = TestNotifierProvider<NotifierT, T>;

/// {@template riverpod.notifier}
/// {@endtemplate}
class TestNotifierProvider<NotifierT extends NotifierBase<T>, T>
    extends NotifierProviderBase<NotifierT, T> with AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.notifier}
  TestNotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = NotifierProviderFamilyBuilder();

  @override
  NotifierProviderElement<NotifierT, T> createElement() {
    return NotifierProviderElement._(this);
  }

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  T _runNotifierBuild(covariant Notifier<T> notifier) {
    return notifier.build();
  }
}

/// The element of [NotifierProvider].
class NotifierProviderElement<NotifierT extends NotifierBase<T>, T>
    extends ProviderElementBase<T> implements NotifierProviderRef<T> {
  NotifierProviderElement._(NotifierProviderBase<NotifierT, T> provider)
      : super(provider);

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as NotifierProviderBase<NotifierT, T>;

    final notifierResult = _notifierNotifier.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

// TODO test if Element fails to init, the provider rethrows the error
    final notifier = notifierResult.requireState;

// TODO test if Element fails to init, the provider rethrows the error
    setState(provider._runNotifierBuild(notifier));
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
