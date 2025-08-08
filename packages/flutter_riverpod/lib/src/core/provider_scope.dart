// ignore_for_file: invalid_use_of_internal_member
part of '../core.dart';

/// {@template riverpod.provider_scope}
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
/// It's optionally possible to specify `overrides` to change the behavior of
/// some providers. This can be useful for testing purposes:
///
/// ```dart
/// testWidgets('Test example', (tester) async {
///   await tester.pumpWidget(
///     ProviderScope(
///       overrides: [
///         // override the behavior of repositoryProvider to provide a fake
///         // implementation for test purposes.
///         repositoryProvider.overrideWithValue(FakeRepository()),
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
/// {@category Core}
final class ProviderScope extends StatefulWidget {
  /// {@macro riverpod.provider_scope}
  const ProviderScope({
    super.key,
    this.overrides = const [],
    this.observers,
    this.retry,
    required this.child,
  });

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
      scope = context
          .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
          ?.widget as UncontrolledProviderScope?;
    }

    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    return scope.container;
  }

  /// The default retry logic used by providers associated to this container.
  ///
  /// The default implementation:
  /// - has unlimited retries
  /// - starts with a delay of 200ms
  /// - doubles the delay on each retry up to 6.4 seconds
  /// - retries all failures
  final Retry? retry;

  /// The part of the widget tree that can use Riverpod and has overridden providers.
  final Widget child;

  /// The listeners that subscribes to changes on providers stored on this [ProviderScope].
  final List<ProviderObserver>? observers;

  /// Information on how to override a provider/family.
  ///
  /// Overrides are created using methods such as [Provider.overrideWith]/[Provider.overrideWithValue].
  ///
  /// This can be used for:
  /// - testing, by mocking a provider.
  /// - dependency injection, to avoid having to pass a value to many
  ///   widgets in the widget tree.
  /// - performance optimization: By using this to inject values to widgets
  ///   using `ref` inside of their constructor, widgets may be able to use
  ///   `const` constructors, which can improve performance.
  ///
  /// **Note**: Overrides only apply to this [ProviderScope] and its descendants.
  /// Ancestors of this [ProviderScope] will not be affected by the overrides.
  final List<Override> overrides;

  @override
  ProviderScopeState createState() => ProviderScopeState();
}

/// Do not use: The [State] of [ProviderScope]
@internal
final class ProviderScopeState extends State<ProviderScope> {
  /// The [ProviderContainer] exposed to [ProviderScope.child].
  @visibleForTesting
  late final ProviderContainer container;
  ProviderContainer? _debugParentOwner;
  var _dirty = false;

  @override
  void initState() {
    super.initState();

    final parent = _getParent();
    if (kDebugMode) {
      _debugParentOwner = parent;
    }

    container = ProviderContainer(
      parent: parent,
      overrides: widget.overrides,
      observers: widget.observers,
      retry: widget.retry,
      onError: (err, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: err,
            stack: stack,
            library: 'riverpod',
          ),
        );
      },
    );
  }

  ProviderContainer? _getParent() {
    final scope = context
        .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
        ?.widget as UncontrolledProviderScope?;

    return scope?.container;
  }

  @override
  void didUpdateWidget(ProviderScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dirty = true;
  }

  void _debugAssertParentDidNotChange() {
    final parent = _getParent();

    if (parent != _debugParentOwner) {
      throw UnsupportedError(
        'ProviderScope was rebuilt with a different ProviderScope ancestor',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) _debugAssertParentDidNotChange();

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
/// This is what makes `ref.watch`/`Consumer`/`ref.read` work.
/// {@endtemplate}
/// {@category Core}
final class UncontrolledProviderScope extends InheritedWidget {
  /// {@macro riverpod.UncontrolledProviderScope}
  const UncontrolledProviderScope({
    super.key,
    required this.container,
    required super.child,
  });

  /// The [ProviderContainer] exposed to the widget tree.
  final ProviderContainer container;

  @override
  bool updateShouldNotify(UncontrolledProviderScope oldWidget) {
    return container != oldWidget.container;
  }

  @override
  // ignore: library_private_types_in_public_api
  _UncontrolledProviderScopeElement createElement() {
    return _UncontrolledProviderScopeElement(this);
  }
}

@sealed
class _UncontrolledProviderScopeElement extends InheritedElement {
  _UncontrolledProviderScopeElement(UncontrolledProviderScope super.widget);

  void Function()? _task;
  ProviderContainer _containerOf(Widget widget) =>
      (widget as UncontrolledProviderScope).container;

  Timer? _timer;

  @override
  void mount(Element? parent, Object? newSlot) {
    if (kDebugMode) {
      debugCanModifyProviders ??= _debugCanModifyProviders;
    }

    _containerOf(widget).scheduler.flutterVsyncs.add(_flutterVsync);
    super.mount(parent, newSlot);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (kDebugMode) {
      _containerOf(widget).debugReassemble();
    }
  }

  void _flutterVsync(void Function() task) {
    assert(_task == null, 'Only one task can be scheduled at a time');
    assert(mounted, 'Cannot schedule a task on an unmounted element');
    _task = task;

    try {
      markNeedsBuild();
    } catch (err) {
      assert(
        _timer == null,
        'Cannot schedule a task while the widget tree is building',
      );
      _timer = Timer(Duration.zero, () {
        _timer = null;
        if (mounted) markNeedsBuild();
      });
    }
  }

  void _debugCanModifyProviders() {
    try {
      markNeedsBuild();
    } catch (err) {
      throw FlutterError.fromParts([
        ErrorSummary(
          'Tried to modify a provider while the widget tree was building.',
        ),
        ErrorDescription(
          '''
If you are encountering this error, chances are you tried to modify a provider
in a widget life-cycle, such as but not limited to:
- build
- initState
- dispose
- didUpdateWidget
- didChangeDependencies

Modifying a provider inside those life-cycles is not allowed, as it could
lead to an inconsistent UI state. For example, two widgets could listen to the
same provider, but incorrectly receive different states.


To fix this problem, you have one of two solutions:
- (preferred) Move the logic for modifying your provider outside of a widget
  life-cycle. For example, maybe you could update your provider inside a button's
  onPressed instead.

- Delay your modification, such as by encapsulating the modification
  in a `Future(() {...})`.
  This will perform your update after the widget tree is done building.
''',
        ),
      ]);
    }
  }

  @override
  void unmount() {
    _timer?.cancel();
    if (kDebugMode && debugCanModifyProviders == _debugCanModifyProviders) {
      debugCanModifyProviders = null;
    }

    _containerOf(widget).scheduler.flutterVsyncs.remove(_flutterVsync);

    super.unmount();
  }

  @override
  Widget build() {
    _task?.call();
    _task = null;
    return super.build();
  }
}

/// Widget testing helpers for flutter_riverpod.
@visibleForTesting
extension RiverpodWidgetTesterX on flutter_test.WidgetTester {
  /// Finds the [ProviderContainer] in the widget tree.
  ///
  /// If [of] is provided, searches for the container within the context of
  /// the specified finder.
  @visibleForTesting
  ProviderContainer container({
    flutter_test.Finder? of,
  }) {
    if (of != null) {
      final element = this.element(of);
      return ProviderScope.containerOf(element, listen: false);
    }

    final scope = widget(flutter_test.find.byType(UncontrolledProviderScope));
    return (scope as UncontrolledProviderScope).container;
  }
}
