import 'package:flutter/foundation.dart' hide describeIdentity;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

/// {@template riverpod.providerscope}
/// A widget that stores the state of providers.
///
/// All Flutter applications using Riverpod must contain a [ProviderScope] at
/// the root of their widget tree. It is done as followed:
///
/// ```dart
/// void main() {
///   runApp(
///     // Enabled Riverpod for the entire application
///     ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// It optionally possible to specify `overrides` to change the behavior of
/// some providers. This can be useful for testing purposes:
///
/// ```dart
/// testWidgets('Test example', (tester) async {
///   await tester.pumpWidget(
///     ProviderScope(
///       overrides: [
///         // override the behavior of repositoryProvider to provide a fake
///         // implementation for test purposes.
///         repositoryProvider.overrideWithProvider(
///           Provider((_) => FakeRepository()),
///         ),
///       ],
///       child: MyApp(),
///     ),
///   );
/// });
/// ```
///
///
/// Similarly, it is possible to insert other [ProviderScope] anywhere inside
/// the widget tree to override the behavior of a provider for only a part of the
/// application:
///
/// ```dart
/// final themeProvider = Provider((ref) => MyTheme.light());
///
/// void main() {
///   runApp(
///     ProviderScope(
///       child: MaterialApp(
///         // Home uses the default behavior for all providers.
///         home: Home(),
///         routes: {
///           // Overrides themeProvider for the /gallery route only
///           '/gallery': (_) => ProviderScope(
///             overrides: [
///               themeProvider.overrideWithValue(MyTheme.dark()),
///             ],
///           ),
///         },
///       ),
///     ),
///   );
/// }
/// ```
///
/// See also:
/// - [ProviderContainer], a Dart-only class that allows manipulating providers
/// - [UncontrolledProviderScope], which exposes a [ProviderContainer] to the widget
///   tree without managing its life-cycles.
/// {@endtemplate}
@sealed
class ProviderScope extends StatefulWidget {
  /// {@macro riverpod.providerscope}
  const ProviderScope({
    Key? key,
    this.overrides = const [],
    this.observers,
    required this.child,
  }) : super(key: key);

  /// Read the current [ProviderContainer] for a [BuildContext].
  static ProviderContainer containerOf(
    BuildContext context, {
    bool listen = true,
  }) {
    UncontrolledProviderScope? scope;

    if (listen) {
      scope = context //
          .dependOnInheritedWidgetOfExactType<UncontrolledProviderScope>();
    } else {
      // TODO(rrousselGit): Test getElementForInheritedWidgetOfExactType return null
      scope = context
          .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
          ?.widget as UncontrolledProviderScope?;
    }

    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    return scope.container;
  }

  /// The part of the widget tree that can use Riverpod and has overridden providers.
  final Widget child;

  /// The listeners that subscribes to changes on providers stored on this [ProviderScope].
  final List<ProviderObserver>? observers;

  /// Informations on how to override a provider/family.
  final List<Override> overrides;

  @override
  ProviderScopeState createState() => ProviderScopeState();
}

/// Do not use: The [State] of [ProviderScope]
@visibleForTesting
@sealed
class ProviderScopeState extends State<ProviderScope> {
  /// The [ProviderContainer] exposed to [ProviderScope.child].
  @visibleForTesting
  // ignore: diagnostic_describe_all_properties
  late ProviderContainer container;
  ProviderContainer? _debugParentOwner;
  var _dirty = false;

  @override
  void initState() {
    super.initState();
    final scope = context
        .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
        ?.widget as UncontrolledProviderScope?;

    assert(() {
      _debugParentOwner = scope?.container;
      return true;
    }(), '');

    container = ProviderContainer(
      parent: scope?.container,
      overrides: widget.overrides,
      observers: widget.observers,
      // TODO How to report to FlutterError?
      // onError: (dynamic error, stack) {
      //   FlutterError.reportError(
      //     FlutterErrorDetails(
      //       library: 'flutter_provider',
      //       exception: error,
      //       stack: stack,
      //     ),
      //   );
      // },
    );
  }

  @override
  void didUpdateWidget(ProviderScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dirty = true;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      final scope = context
          .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
          ?.widget as UncontrolledProviderScope?;

      if (scope?.container != _debugParentOwner) {
        throw UnsupportedError(
          'ProviderScope was rebuilt with a different ProviderScope ancestor',
        );
      }
      return true;
    }(), '');
    if (_dirty) {
      _dirty = false;
      container.updateOverrides(widget.overrides);
    }

    return UncontrolledProviderScope(
      container: container,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    container.dispose();
    super.dispose();
  }
}

/// {@template riverpod.UncontrolledProviderScope}
/// Expose a [ProviderContainer] to the widget tree.
///
/// This is what makes `ref.watch(`/`Consumer`/`context.read` work.
/// {@endtemplate}
@sealed
class UncontrolledProviderScope extends InheritedWidget {
  /// {@macro riverpod.UncontrolledProviderScope}
  const UncontrolledProviderScope({
    Key? key,
    required this.container,
    required Widget child,
  }) : super(key: key, child: child);

  /// The [ProviderContainer] exposed to the widget tree.
  final ProviderContainer container;

  @override
  bool updateShouldNotify(UncontrolledProviderScope oldWidget) {
    return container != oldWidget.container;
  }

  @override
  _UncontrolledProviderScopeElement createElement() {
    return _UncontrolledProviderScopeElement(this);
  }
}

@sealed
class _UncontrolledProviderScopeElement extends InheritedElement {
  _UncontrolledProviderScopeElement(UncontrolledProviderScope widget)
      : super(widget);

  void Function()? _task;
  bool _mounted = true;

  ProviderContainer _containerOf(Widget widget) =>
      (widget as UncontrolledProviderScope).container;

  @override
  void mount(Element? parent, Object? newSlot) {
    if (kDebugMode) {
      _containerOf(widget).debugCanModifyProviders = _debugCanModifyProviders;
    }
    assert(
      _containerOf(widget).vsyncOverride == null,
      'The ProviderContainer was already associated with a different widget',
    );
    _containerOf(widget).vsyncOverride = _flutterVsync;

    super.mount(parent, newSlot);
  }

  @override
  void update(ProxyWidget newWidget) {
    if (kDebugMode) {
      _containerOf(widget).debugCanModifyProviders = null;
      _containerOf(newWidget).debugCanModifyProviders =
          _debugCanModifyProviders;
    }

    _containerOf(widget).vsyncOverride = null;
    assert(
      _containerOf(newWidget).vsyncOverride == null,
      'The ProviderContainer was already associated with a different widget',
    );
    _containerOf(newWidget).vsyncOverride = _flutterVsync;

    super.update(newWidget);
  }

  void _flutterVsync(void Function() task) {
    assert(_task == null, 'Only one task can be scheduled at a time');
    _task = task;
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_mounted) markNeedsBuild();
    });
  }

  void _debugCanModifyProviders() {
    markNeedsBuild();
  }

  @override
  void unmount() {
    _mounted = false;
    if (kDebugMode) {
      _containerOf(widget).debugCanModifyProviders = null;
    }

    _containerOf(widget).vsyncOverride = null;
    super.unmount();
  }

  @override
  Widget build() {
    _task?.call();
    _task = null;
    return super.build();
  }
}
