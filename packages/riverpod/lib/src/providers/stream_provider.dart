import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/listenable.dart';
import '../common/result.dart';
import '../framework.dart';
import 'async_notifier.dart';
import 'future_provider.dart' show FutureProvider;
import 'provider.dart' show Provider;

ProviderElementProxy<AsyncValue<T>, Future<T>> _future<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) => FutureHandlerProviderElementMixin.futureNotifierOf(
      element as FutureHandlerProviderElementMixin<T>,
    ),
  );
}

ProviderElementProxy<AsyncValue<T>, Stream<T>> _stream<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Stream<T>>(
    that,
    (element) {
      return (element as StreamProviderElement<T>)._streamNotifier;
    },
  );
}

abstract class _StreamProviderBase<T> extends ProviderBase<AsyncValue<T>> {
  const _StreamProviderBase({
    required super.allTransitiveDependencies,
    required super.dependencies,
    required super.name,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required DebugGetCreateSourceHash? debugGetCreateSourceHash,
  }) : _debugGetCreateSourceHash = debugGetCreateSourceHash;

  ProviderListenable<Future<T>> get future;

  @Deprecated(
    '.stream will be removed in 3.0.0. As a replacement, either listen to the '
    'provider itself (AsyncValue) or .future.',
  )
  ProviderListenable<Stream<T>> get stream;

  Stream<T> _create(covariant StreamProviderElement<T> ref);

  final DebugGetCreateSourceHash? _debugGetCreateSourceHash;
  @override
  String? debugGetCreateSourceHash() => _debugGetCreateSourceHash?.call();
}

/// {@macro riverpod.provider_ref_base}
/// - [StreamProviderRef.state], the value currently exposed by this provider.
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class StreamProviderRef<State> implements Ref<AsyncValue<State>> {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  ///
  /// Will throw if the provider threw during creation.
  AsyncValue<State> get state;
  set state(AsyncValue<State> newState);
}

/// {@template riverpod.stream_provider}
/// Creates a stream and exposes its latest event.
///
/// [StreamProvider] is identical in behavior/usage to [FutureProvider], modulo
/// the fact that the value created is a [Stream] instead of a [Future].
///
/// It can be used to express a value asynchronously loaded that can change over
/// time, such as an editable `Message` coming from a web socket:
///
/// ```dart
/// final messageProvider = StreamProvider.autoDispose<String>((ref) async* {
///   // Open the connection
///   final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
///
///   // Close the connection when the stream is destroyed
///   ref.onDispose(() => channel.sink.close());
///
///   // Parse the value received and emit a Message instance
///   await for (final value in channel.stream) {
///     yield value.toString();
///   }
/// });
/// ```
///
/// Which the UI can then listen:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   AsyncValue<String> message = ref.watch(messageProvider);
///
///   return message.when(
///     loading: () => const CircularProgressIndicator(),
///     error: (err, stack) => Text('Error: $err'),
///     data: (message) {
///       return Text(message);
///     },
///   );
/// }
/// ```
///
/// **Note**:
/// When listening to web sockets, firebase, or anything that consumes resources,
/// it is important to use [StreamProvider.autoDispose] instead of simply [StreamProvider].
///
/// This ensures that the resources are released when no longer needed as,
/// by default, a [StreamProvider] is almost never destroyed.
///
/// See also:
///
/// - [Provider], a provider that synchronously creates a value
/// - [FutureProvider], a provider that asynchronously exposes a value that
///   can change over time.
/// - [future], to obtain the last value emitted by a [Stream].
/// - [StreamProvider.family], to create a [StreamProvider] from external parameters
/// - [StreamProvider.autoDispose], to destroy the state of a [StreamProvider] when no longer needed.
/// {@endtemplate}
class StreamProvider<T> extends _StreamProviderBase<T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<AsyncValue<T>>,
        AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.stream_provider}
  StreamProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: false,
        );

  /// An implementation detail of Riverpod
  @internal
  StreamProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
    super.isAutoDispose = false,
  }) : super();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  // ignore: deprecated_member_use_from_same_package
  final Stream<T> Function(StreamProviderRef<T> ref) _createFn;

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<Future<T>> future = _future(this);

  @Deprecated(
    '.stream will be removed in 3.0.0. As a replacement, either listen to the '
    'provider itself (AsyncValue) or .future.',
  )
  @override
  late final AlwaysAliveRefreshable<Stream<T>> stream = _stream(this);

  @override
  Stream<T> _create(StreamProviderElement<T> ref) => _createFn(ref);

  @internal
  @override
  StreamProviderElement<T> createElement() => StreamProviderElement(this);

  /// {@macro riverpod.override_with}
  @mustBeOverridden
  // ignore: deprecated_member_use_from_same_package
  Override overrideWith(Create<Stream<T>, StreamProviderRef<T>> create) {
    return ProviderOverride(
      origin: this,
      override: StreamProvider<T>.internal(
        create,
        from: from,
        argument: argument,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// The element of [StreamProvider].
@internal
class StreamProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    with
        FutureHandlerProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        StreamProviderRef<T> {
  /// The element of [StreamProvider].
  @internal
  // ignore: library_private_types_in_public_api
  StreamProviderElement(_StreamProviderBase<T> super._provider);

  final _streamNotifier = $ElementLense<Stream<T>>();
  final StreamController<T> _streamController = StreamController<T>.broadcast();

  @override
  void create({required bool didChangeDependency}) {
    asyncTransition(AsyncLoading<T>(), seamless: !didChangeDependency);
    _streamNotifier.result ??= $Result.data(_streamController.stream);

    handleStream(
      () {
        final provider = this.provider as _StreamProviderBase<T>;
        return provider._create(this);
      },
      didChangeDependency: didChangeDependency,
    );
  }

  @override
  void dispose() {
    super.dispose();

    /// The controller isn't recreated on provider rebuild. So we only close it
    /// when the element is destroyed, not on "ref.onDispose".
    _streamController.close();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_streamNotifier);
  }

  @override
  void onData(AsyncData<T> value, {bool seamless = false}) {
    if (!_streamController.isClosed) {
      // The controller might be closed if onData is executed post dispose. Cf onData
      _streamController.add(value.value);
    }
    super.onData(value, seamless: seamless);
  }

  @override
  void onError(AsyncError<T> value, {bool seamless = false}) {
    if (!_streamController.isClosed) {
      // The controller might be closed if onError is executed post dispose. Cf onError
      _streamController.addError(value.error, value.stackTrace);
    }
    super.onError(value, seamless: seamless);
  }
}

/// The [Family] of [StreamProvider].
// ignore: deprecated_member_use_from_same_package
class StreamProviderFamily<R, Arg> extends FamilyBase<StreamProviderRef<R>,
    AsyncValue<R>, Arg, Stream<R>, StreamProvider<R>> {
  /// The [Family] of [StreamProvider].
  StreamProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: StreamProvider<R>.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: false,
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Stream<R> Function(StreamProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, StreamProvider<R>>(
      this,
      (arg) => StreamProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeStreamProviderRef<State>
    extends StreamProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

/// {@macro riverpod.stream_provider}
class AutoDisposeStreamProvider<T> extends _StreamProviderBase<T>
    with AsyncSelector<T> {
  /// {@macro riverpod.stream_provider}
  AutoDisposeStreamProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: true,
        );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeStreamProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
    super.isAutoDispose = true,
  }) : super();

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamily.new;

  // ignore: deprecated_member_use_from_same_package
  final Stream<T> Function(AutoDisposeStreamProviderRef<T> ref) _createFn;

  @override
  Stream<T> _create(AutoDisposeStreamProviderElement<T> ref) => _createFn(ref);

  @internal
  @override
  AutoDisposeStreamProviderElement<T> createElement() {
    return AutoDisposeStreamProviderElement(this);
  }

  @override
  late final Refreshable<Future<T>> future = _future(this);

  @Deprecated(
    '.stream will be removed in 3.0.0. As a replacement, either listen to the '
    'provider itself (AsyncValue) or .future.',
  )
  @override
  late final Refreshable<Stream<T>> stream = _stream(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<Stream<T>, AutoDisposeStreamProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStreamProvider<T>.internal(
        create,
        from: from,
        argument: argument,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// The element of [AutoDisposeStreamProvider].
@internal
class AutoDisposeStreamProviderElement<T> extends StreamProviderElement<T>
    with
        AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStreamProviderRef<T> {
  /// The [ProviderElementBase] for [StreamProvider]
  AutoDisposeStreamProviderElement(
    AutoDisposeStreamProvider<T> super._provider,
  );
}

/// The [Family] of [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderFamily<R, Arg> extends FamilyBase<
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeStreamProviderRef<R>,
    AsyncValue<R>,
    Arg,
    Stream<R>,
    AutoDisposeStreamProvider<R>> {
  /// The [Family] of [AutoDisposeStreamProvider].
  AutoDisposeStreamProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeStreamProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: true,
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Stream<R> Function(AutoDisposeStreamProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, AutoDisposeStreamProvider<R>>(
      this,
      (arg) => AutoDisposeStreamProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}
