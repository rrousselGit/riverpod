part of '../async_notifier.dart';

abstract class AsyncNotifier<State> extends AsyncNotifierBase<State> {
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

/// {@macro riverpod.providerrefbase}
abstract class AsyncNotifierProviderRef<T> implements Ref<AsyncValue<T>> {}

/// {@template riverpod.notifier}
/// {@endtemplate}
class AsyncNotifierProvider<NotifierT extends AsyncNotifierBase<T>, T>
    extends _AsyncNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.notifier}
  AsyncNotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  // /// {@macro riverpod.autoDispose}
  // static const autoDispose = AutoDisposeAsyncNotifierProviderBuilder();

  // /// {@macro riverpod.family}
  // static const family = AsyncNotifierProviderFamilyBuilder();

  @override
  AsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AsyncNotifierProviderElement._(this);
  }

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  late final AlwaysAliveProviderListenable<Future<T>> future = _future<T>(this);
}

/// The element of [AsyncNotifierProvider].
class AsyncNotifierProviderElement<NotifierT extends AsyncNotifierBase<T>, T>
    extends ProviderElementBase<AsyncValue<T>>
    implements AsyncNotifierProviderRef<T> {
  AsyncNotifierProviderElement._(
      _AsyncNotifierProviderBase<NotifierT, T> provider)
      : super(provider);

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();
  final _futureNotifier = ProxyElementValueNotifier<Future<T>>();

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _AsyncNotifierProviderBase<NotifierT, T>;

    final notifierResult =
        _notifierNotifier.result ??= Result.guard(provider._createNotifier);

// TODO initialize Completer for .future

    // TODO test notifier constructor throws -> provider emits AsyncError
    // TODO test notifier constructor throws -> .notifier rethrows the error
    // TODO test notifier constructor throws -> .future emits Future.error
    notifierResult.when(
      error: (err, stack) {
        _futureNotifier.result = Result.data(Future.error(err, stack));
        setState(AsyncError(err, stack));
      },
      data: (notifier) {
        notifier._setElement(this);
        final futureOrResult = Result.guard(notifier.build);

        // TODO test build throws -> provider emits AsyncError synchronously & .future emits Future.error
        // TODO test build resolves with error -> emits AsyncError & .future emits Future.error
        // TODO test build emits value -> .future emits value & provider emits AsyncData
        futureOrResult.when(
          error: (err, stack) {},
          data: (futureOr) {
            if (futureOr is Future<T>) {
              _futureNotifier.result = Result.data(
                futureOr.then(
                  (_) => requireState.when<T>(
                    loading: () => throw StateError(
                        'Failed to initialize the provider. Did you forget to set a value during "build"?'),
                    error: Error.throwWithStackTrace,
                    data: (data) => data,
                  ),
                ),
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
}
