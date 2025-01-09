import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/listenable.dart';
import '../common/result.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'provider.dart' show Provider;

/// Implementation detail of `riverpod_generator`.
/// Do not use, as this may be removed at any time.
@internal
base mixin $StreamProvider<StateT> on ProviderBase<AsyncValue<StateT>> {
  Stream<StateT> create(Ref ref);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StateT> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $AsyncValueProvider<StateT>(value),
    );
  }
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
base class StreamProvider<StateT>
    extends $FunctionalProvider<AsyncValue<StateT>, Stream<StateT>>
    with
        $FutureModifier<StateT>,
        $StreamProvider<StateT>,
        LegacyProviderMixin<AsyncValue<StateT>> {
  /// {@macro riverpod.stream_provider}
  StreamProvider(
    this._create, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
        );

  /// An implementation detail of Riverpod
  @internal
  StreamProvider.internal(
    this._create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  final Create<Stream<StateT>> _create;

  @override
  Stream<StateT> create(Ref ref) => _create(ref);

  @internal
  @override
  $StreamProviderElement<StateT> $createElement($ProviderPointer pointer) {
    return $StreamProviderElement(this, pointer);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  $FunctionalProvider<AsyncValue<StateT>, Stream<StateT>> $copyWithCreate(
    Create<Stream<StateT>> create,
  ) {
    return StreamProvider<StateT>.internal(
      create,
      name: name,
      dependencies: null,
      allTransitiveDependencies: null,
      from: from,
      argument: argument,
      isAutoDispose: isAutoDispose,
      retry: retry,
    );
  }
}

/// The element of [StreamProvider].
@internal
class $StreamProviderElement<StateT> extends ProviderElement<AsyncValue<StateT>>
    with FutureModifierElement<StateT> {
  /// The element of [StreamProvider].
  $StreamProviderElement(this.provider, super.pointer);

  @override
  final $StreamProvider<StateT> provider;

  final _streamNotifier = $ElementLense<Stream<StateT>>();
  final StreamController<StateT> _streamController =
      StreamController<StateT>.broadcast();

  @override
  WhenComplete create(
    Ref ref, {
    required bool didChangeDependency,
    required bool isMount,
  }) {
    _streamNotifier.result ??= $Result.data(_streamController.stream);

    return handleStream(
      () => provider.create(ref),
      seamless: !didChangeDependency,
      isMount: isMount,
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
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function($ElementLense element) listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );
    listenableVisitor(_streamNotifier);
  }

  @override
  void onData(AsyncData<StateT> value, {bool seamless = false}) {
    if (!_streamController.isClosed) {
      // The controller might be closed if onData is executed post dispose. Cf onData
      _streamController.add(value.value);
    }
    super.onData(value, seamless: seamless);
  }

  @override
  void onError(AsyncError<StateT> value, {bool seamless = false}) {
    if (!_streamController.isClosed) {
      // The controller might be closed if onError is executed post dispose. Cf onError
      _streamController.addError(value.error, value.stackTrace);
    }
    super.onError(value, seamless: seamless);
  }

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previous,
    AsyncValue<StateT> next,
  ) {
    return FutureModifierElement.handleUpdateShouldNotify(
      previous,
      next,
    );
  }
}

/// The [Family] of a [StreamProvider]
class StreamProviderFamily<StateT, ArgT> extends FunctionalFamily<
    AsyncValue<StateT>, ArgT, Stream<StateT>, StreamProvider<StateT>> {
  StreamProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: StreamProvider<StateT>.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// Implementation detail of the code-generator.
  @internal
  StreamProviderFamily.internal(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : super(providerFactory: StreamProvider<StateT>.internal);
}
