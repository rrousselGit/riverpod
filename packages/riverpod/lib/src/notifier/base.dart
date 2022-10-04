part of '../notifier.dart';

/// A [Notifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessNotifier<State> extends NotifierBase<State> {
  @override
  late final NotifierProviderElement<NotifierBase<State>, State> _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element = element as NotifierProviderElement<NotifierBase<State>, State>;
  }

  @override
  NotifierProviderRef<State> get ref => _element;
}

/// {@template riverpod.notifier}
/// A class which exposes a state that can change over time.
///
/// For example, [Notifier] can be used to implement a counter by doing:
///
/// ```dart
/// final counterProvider = NotifierProvider<Counter, int>(Counter.new);
///
/// class Counter extends Notifier<int> {
///   @override
///   int build() {
///     // Inside "build", we return the initial state of the counter.
///     return 0;
///   }
///
///   void increment() {
///     state++;
///   }
/// }
/// ```
///
/// We can then listen to the counter inside widgets by doing:
///
/// ```dart
/// Consumer(
///   builder: (context, ref) {
///     return Text('count: ${ref.watch(counterProvider)}');
///   },
/// )
/// ```
///
/// And finally, we can update the counter by doing:
///
/// ```dart
/// Consumer(
///   builder: (context, ref) {
///     return ElevatedButton(
///       onTap: () => ref.read(counterProvider.notifier).increment(),
///       child: const Text('increment'),
///     );
///   },
/// )
/// ```
///
/// The state of [Notifier] is expected to be initialized synchronously.
/// For asynchronous initializations, see [AsyncNotifier].
/// {@endtemplate}
abstract class Notifier<State> extends BuildlessNotifier<State> {
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
/// A Provider which exposes a [Notifier] and listens to it.
///
/// See also [Notifier] for more information.
/// {@endtemplate}
typedef NotifierProvider<NotifierT extends Notifier<T>, T>
    = NotifierProviderImpl<NotifierT, T>;

/// The implementation of [NotifierProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeNotifierProvider].
///
/// This enables tests to execute on both [NotifierProvider] and
/// [AutoDisposeNotifierProvider] at the same time.
@internal
class NotifierProviderImpl<NotifierT extends NotifierBase<T>, T>
    extends NotifierProviderBase<NotifierT, T> with AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.notifier_provider}
  NotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

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
  T runNotifierBuild(NotifierBase<T> notifier) {
    return (notifier as Notifier<T>).build();
  }
}

/// The element of [NotifierProvider].
class NotifierProviderElement<NotifierT extends NotifierBase<T>, T>
    extends ProviderElementBase<T> implements NotifierProviderRef<T> {
  NotifierProviderElement._(NotifierProviderBase<NotifierT, T> super.provider);

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as NotifierProviderBase<NotifierT, T>;

    final notifierResult = _notifierNotifier.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

    // If the Notifier failed to create (such as if the constructor has an assert exception),
    // then we purposefully rethrow the error.
    // This way, doing `watch(provider)` will rethrow the error.
    final notifier = notifierResult.requireState;

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
