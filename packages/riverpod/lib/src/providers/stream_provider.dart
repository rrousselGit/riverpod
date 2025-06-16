import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/internal_lints.dart';
import '../common/listenable.dart';
import '../common/result.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'provider.dart' show Provider;

/// Implementation detail of `riverpod_generator`.
/// Do not use, as this may be removed at any time.
@internal
@publicInCodegen
base mixin $StreamProvider<ValueT>
    on $FunctionalProvider<AsyncValue<ValueT>, ValueT, Stream<ValueT>> {
  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ValueT> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $AsyncValueProvider<ValueT>(value),
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
/// {@category Providers}
final class StreamProvider<ValueT>
    extends $FunctionalProvider<AsyncValue<ValueT>, ValueT, Stream<ValueT>>
    with
        $FutureModifier<ValueT>,
        $StreamProvider<ValueT>,
        LegacyProviderMixin<AsyncValue<ValueT>> {
  /// {@macro riverpod.stream_provider}
  StreamProvider(
    this._create, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
        );

  /// An implementation detail of Riverpod
  /// @nodoc
  @internal
  StreamProvider.internal(
    this._create, {
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  final Create<Stream<ValueT>> _create;

  /// @nodoc
  @internal
  @override
  Stream<ValueT> create(Ref ref) => _create(ref);

  /// @nodoc
  @internal
  @override
  $StreamProviderElement<ValueT> $createElement($ProviderPointer pointer) {
    return $StreamProviderElement(pointer);
  }
}

/// The element of [StreamProvider].
@internal
@publicInCodegen
class $StreamProviderElement<ValueT> extends $FunctionalProviderElement<
    AsyncValue<ValueT>,
    ValueT,
    Stream<ValueT>> with FutureModifierElement<ValueT> {
  /// The element of [StreamProvider].
  $StreamProviderElement(super.pointer);

  final _streamNotifier = $Observable<Stream<ValueT>>();
  final StreamController<ValueT> _streamController =
      StreamController<ValueT>.broadcast();

  @override
  WhenComplete create(Ref ref) {
    _streamNotifier.result ??= $Result.data(_streamController.stream);

    return handleStream(ref, () => provider.create(ref));
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
    void Function($Observable element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_streamNotifier);
  }

  @override
  void onData(AsyncData<ValueT> value, {bool seamless = false}) {
    if (!_streamController.isClosed) {
      // The controller might be closed if onData is executed post dispose. Cf onData
      _streamController.add(value.value);
    }
    super.onData(value, seamless: seamless);
  }

  @override
  void onError(AsyncError<ValueT> value, {bool seamless = false}) {
    if (!_streamController.isClosed) {
      // The controller might be closed if onError is executed post dispose. Cf onError
      _streamController.addError(value.error, value.stackTrace);
    }
    super.onError(value, seamless: seamless);
  }
}

/// The [Family] of a [StreamProvider]
@publicInMisc
final class StreamProviderFamily<ValueT, ArgT> extends FunctionalFamily<
    AsyncValue<ValueT>, ValueT, ArgT, Stream<ValueT>, StreamProvider<ValueT>> {
  /// The [Family] of a [StreamProvider]
  /// @nodoc
  @internal
  StreamProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: StreamProvider<ValueT>.internal,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// Implementation detail of the code-generator.
  /// @nodoc
  @internal
  StreamProviderFamily.internal(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : super(providerFactory: StreamProvider<ValueT>.internal);
}
