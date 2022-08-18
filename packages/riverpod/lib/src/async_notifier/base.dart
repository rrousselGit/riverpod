part of '../async_notifier.dart';

/// A [AsyncNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessAsyncNotifier<State> extends AsyncNotifierBase<State> {
  @override
  late final AsyncNotifierProviderElement<AsyncNotifierBase<State>, State>
      _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element
        as AsyncNotifierProviderElement<AsyncNotifierBase<State>, State>;
  }

  @override
  AsyncNotifierProviderRef<State> get ref => _element;
}

/// {@template riverpod.asyncnotifier}
/// A [Notifier] implementation that is asynchronously initialized.
/// {@endtemplate}
// TODO add usage example
abstract class AsyncNotifier<State> extends BuildlessAsyncNotifier<State> {
  /// {@template riverpod.asyncnotifier.build}
  /// Initialize an [AsyncNotifier].
  ///
  /// It is safe to use [Ref.watch] or [Ref.listen] inside this method.
  ///
  /// If a dependency of this [AsyncNotifier] (when using [Ref.watch]) changes,
  /// then [build] will be re-executed. On the other hand, the [AsyncNotifier]
  /// will **not** be recreated. Its instance will be preserved between
  /// executions of [build].
  ///
  /// If this method throws or returns a future that fails, the error
  /// will be caught and an [AsyncError] will be emitted.
  /// {@endtemplate}
  @visibleForOverriding
  FutureOr<State> build();
}

/// {@macro riverpod.providerrefbase}
abstract class AsyncNotifierProviderRef<T> implements Ref<AsyncValue<T>> {}

/// {@template riverpod.async_notifier_provider}
/// {@endtemplate}
typedef AsyncNotifierProvider<NotifierT extends AsyncNotifier<T>, T>
    = AsyncNotifierProviderImpl<NotifierT, T>;

/// The implementation of [AsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeAsyncNotifierProvider].
///
/// This enables tests to execute on both [AsyncNotifierProvider] and
/// [AutoDisposeAsyncNotifierProvider] at the same time.
@visibleForTesting
@internal
class AsyncNotifierProviderImpl<NotifierT extends AsyncNotifierBase<T>, T>
    extends AsyncNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.async_notifier_provider}
  AsyncNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = AsyncNotifierProviderFamilyBuilder();

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
  FutureOr<T> runNotifierBuild(AsyncNotifierBase<T> notifier) {
    return (notifier as AsyncNotifier<T>).build();
  }
}

/// The element of [AsyncNotifierProvider].
class AsyncNotifierProviderElement<NotifierT extends AsyncNotifierBase<T>, T>
    extends ProviderElementBase<AsyncValue<T>>
    implements AsyncNotifierProviderRef<T> {
  AsyncNotifierProviderElement._(
      AsyncNotifierProviderBase<NotifierT, T> provider)
      : super(provider);

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();
  final _futureNotifier = ProxyElementValueNotifier<Future<T>>();

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as AsyncNotifierProviderBase<NotifierT, T>;

    final notifierResult = _notifierNotifier.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

// TODO initialize Completer for .future

    // TODO test notifier constructor throws -> provider emits AsyncError
    // TODO test notifier constructor throws -> .notifier rethrows the error
    // TODO test notifier constructor throws -> .future emits Future.error
    notifierResult.when(
      error: (err, stack) {
        _futureNotifier.result = Result.data(
          Future.error(err, stack)
            // TODO test ignore
            ..ignore(),
        );
        setState(AsyncError(err, stack));
      },
      data: (notifier) {
        asyncTransition(didChangeDependency: didChangeDependency);
        final futureOrResult = Result.guard(
          () => provider.runNotifierBuild(notifier),
        );

        // TODO test build throws -> provider emits AsyncError synchronously & .future emits Future.error
        // TODO test build resolves with error -> emits AsyncError & .future emits Future.error
        // TODO test build emits value -> .future emits value & provider emits AsyncData
        futureOrResult.when(
          error: (err, stack) {
            setState(AsyncError(err, stack));
            _futureNotifier.result = Result.data(
              Future<T>.error(err, stack)
                // TODO test ignore
                ..ignore(),
            );
          },
          data: (futureOr) {
            if (futureOr is Future<T>) {
              _futureNotifier.result = Result.data(futureOr);

              var running = true;
              onDispose(() => running = false);

              // TODO stop listening on dispose
              futureOr.then(
                (value) {
                  if (running) setState(AsyncData(value));
                },
                // ignore: avoid_types_on_closure_parameters
                onError: (Object err, StackTrace stack) {
                  if (running) setState(AsyncError(err, stack));
                },
              );
            } else {
              _futureNotifier.result = Result.data(SynchronousFuture(futureOr));
              setState(AsyncData(futureOr));
            }
          },
        );
      },
    );
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
  bool updateShouldNotify(AsyncValue<T> previous, AsyncValue<T> next) {
    return _notifierNotifier.result?.stateOrNull
            ?.updateShouldNotify(previous, next) ??
        true;
  }
}
