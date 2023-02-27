part of '../stream_notifier.dart';

/// A [StreamNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessStreamNotifier<State>
    extends StreamNotifierBase<State> {
  @override
  late final StreamNotifierProviderElement<StreamNotifierBase<State>, State>
      _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element
        as StreamNotifierProviderElement<StreamNotifierBase<State>, State>;
  }

  @override
  StreamNotifierProviderRef<State> get ref => _element;
}

/// {@template riverpod.StreamNotifier}
/// A [Notifier] implementation that is asynchronously initialized.
///
/// It is commonly used for:
/// - Caching a network request while also allowing to perform side-effects.
///   For example, `build` could fetch information about the current "user".
///   And the [StreamNotifier] could expose methods such as "setName",
///   to allow changing the current user name.
/// - Initializing a [Notifier] from an asynchronous source of data.
///   For example, obtaining the initial state of [Notifier] from a local database.
/// {@endtemplate}
// TODO add usage example
abstract class StreamNotifier<State> extends BuildlessStreamNotifier<State> {
  /// {@template riverpod.StreamNotifier.build}
  /// Initialize an [StreamNotifier].
  ///
  /// It is safe to use [Ref.watch] or [Ref.listen] inside this method.
  ///
  /// If a dependency of this [StreamNotifier] (when using [Ref.watch]) changes,
  /// then [build] will be re-executed. On the other hand, the [StreamNotifier]
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
abstract class StreamNotifierProviderRef<T> implements Ref<AsyncValue<T>> {}

/// {@template riverpod.async_notifier_provider}
/// {@endtemplate}
typedef StreamNotifierProvider<NotifierT extends StreamNotifier<T>, T>
    = StreamNotifierProviderImpl<NotifierT, T>;

/// The implementation of [StreamNotifierProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeStreamNotifierProvider].
///
/// This enables tests to execute on both [StreamNotifierProvider] and
/// [AutoDisposeStreamNotifierProvider] at the same time.
@visibleForTesting
@internal
class StreamNotifierProviderImpl<NotifierT extends StreamNotifierBase<T>, T>
    extends StreamNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.async_notifier_provider}
  StreamNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  StreamNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamNotifierProviderFamilyBuilder();

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _future<T>(this);

  @override
  StreamNotifierProviderElement<NotifierT, T> createElement() {
    return StreamNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> runNotifierBuild(StreamNotifierBase<T> notifier) {
    return (notifier as StreamNotifier<T>).build();
  }

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamNotifierProviderImpl<NotifierT, T>.internal(
        create,
        from: from,
        argument: argument,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}

/// The element of [StreamNotifierProvider].
class StreamNotifierProviderElement<NotifierT extends StreamNotifierBase<T>, T>
    extends ProviderElementBase<AsyncValue<T>>
    with FutureHandlerProviderElementMixin<T>
    implements StreamNotifierProviderRef<T> {
  StreamNotifierProviderElement._(
    StreamNotifierProviderBase<NotifierT, T> super.provider,
  );

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as StreamNotifierProviderBase<NotifierT, T>;

    final notifierResult = _notifierNotifier.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

    // TODO test notifier constructor throws -> provider emits AsyncError
    // TODO test notifier constructor throws -> .notifier rethrows the error
    // TODO test notifier constructor throws -> .future emits Future.error
    notifierResult.when(
      error: (error, stackTrace) {
        onError(AsyncError(error, stackTrace), seamless: !didChangeDependency);
      },
      data: (notifier) {
        handleFuture(
          () => provider.runNotifierBuild(notifier),
          didChangeDependency: didChangeDependency,
        );
      },
    );
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase<Object?> element) elementVisitor,
    required void Function(ProxyElementValueNotifier<Object?> element)
        notifierVisitor,
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

extension<T> on Stream<T> {
  void lastCancelable(
    void Function(Future<T>, CancelAsyncSubscription) last, {
    required Object Function() orElseError,
  }) {
    late StreamSubscription<T> subscription;
    final completer = Completer<T>();

    Result<T>? result;
    subscription = listen(
      (event) => result = Result.data(event),
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error, StackTrace stackTrace) {
        result = Result.error(error, stackTrace);
      },
      onDone: () {
        if (result != null) {
          result!.map(
            data: (result) => completer.complete(result.state),
            error: (result) {
              // TODO: shoould this be reported to the zone?
              completer.future.ignore();
              completer.completeError(result.error, result.stackTrace);
            },
          );
        } else {
          // The error happens after the associated provider is disposed.
          // As such, it's normally never read. Reporting this error as uncaught
          // would cause too many false-positives. And the edge-cases that
          // do reach this error will throw anyway
          completer.future.ignore();

          completer.completeError(
            orElseError(),
            StackTrace.current,
          );
        }
      },
    );

    last(completer.future, subscription.cancel);
  }
}
