part of '../notifier.dart';

/// {@template riverpod.notifier}
/// A class which exposes a state that can change over time.
///
/// The state of [Notifier] is expected to be initialized synchronously.
/// For asynchronous initializations, see [AsyncNotifier].
/// {@endtemplate}
abstract class Notifier<State> extends NotifierBase<State> {
  @override
  late final NotifierProviderElement<Notifier<State>, State> _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element = element as NotifierProviderElement<Notifier<State>, State>;
  }

  @override
  NotifierProviderRef<State> get ref => _element;

  /// {@template riverpod.notifier.build}
  /// Initialize a [Notifier].
  ///
  /// It is safe to use [Ref.watch] or [Ref.listen] inside this method.
  ///
  /// If a dependency of this [Notifier] (when using [Ref.watch]) changes,
  /// then [build] will be re-executed. On the other hand, the [Notifier]
  /// will **not** be recreated. Its instance will be preserved between
  /// executions of [build].
  ///
  /// If this method throws, reading this provider will rethrow the error.
  /// {@endtemplate}
  @visibleForOverriding
  State build();
}

/// {@macro riverpod.providerrefbase}
abstract class NotifierProviderRef<T> implements Ref<T> {}

/// {@template riverpod.notifier_provider}
/// {@endtemplate}
typedef NotifierProvider<NotifierT extends Notifier<T>, T>
    = TestNotifierProvider<NotifierT, T>;

/// The implementation of [NotifierProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeNotifierProvider].
///
/// This enables tests to execute on both [NotifierProvider] and
/// [AutoDisposeNotifierProvider] at the same time.
@internal
class TestNotifierProvider<NotifierT extends NotifierBase<T>, T>
    extends NotifierProviderBase<NotifierT, T> with AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.notifier_provider}
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
  T runNotifierBuild(covariant Notifier<T> notifier) {
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
    setState(provider.runNotifierBuild(notifier));
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

  @override
  bool updateShouldNotify(T previous, T next) {
    return _notifierNotifier.result?.stateOrNull
            ?.updateShouldNotify(previous, next) ??
        true;
  }
}
