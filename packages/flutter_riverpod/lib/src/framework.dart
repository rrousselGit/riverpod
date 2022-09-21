import 'package:flutter/foundation.dart' hide describeIdentity;
import 'package:flutter/material.dart';
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
@sealed
class ProviderScope extends StatefulWidget {
  /// {@macro riverpod.providerscope}
  const ProviderScope({
    super.key,
    this.overrides = const [],
    this.observers,
    this.parent,
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

  /// Explicitly override the parent [ProviderContainer] that this [ProviderScope]
  /// would be a descendant of.
  ///
  /// A common use-case is to allow modals to access scoped providers, as they
  /// would otherwise be unable to since they would be in a different branch
  /// of the widget tree.
  ///
  /// That can be achieved with:
  ///
  /// ```dart
  /// ElevatedButton(
  ///   onTap: () {
  ///     final container = ProviderScope.containerOf(context);
  ///     showDialog(
  ///       context: context,
  ///       builder: (context) {
  ///         return ProviderScope(parent: container, child: MyModal());
  ///       },
  ///     );
  ///   },
  ///   child: Text('show modal'),
  /// )
  /// ```
  ///
  ///
  /// The [parent] variable must never change.
  final ProviderContainer? parent;

  /// The part of the widget tree that can use Riverpod and has overridden providers.
  final Widget child;

  /// The listeners that subscribes to changes on providers stored on this [ProviderScope].
  final List<ProviderObserver>? observers;

  /// Information on how to override a provider/family.
  final List<Override> overrides;

  @override
  ProviderScopeState createState() => ProviderScopeState();
}

/// Do not use: The [State] of [ProviderScope]
@visibleForTesting
@sealed
@internal
class ProviderScopeState extends State<ProviderScope> {
  /// The [ProviderContainer] exposed to [ProviderScope.child].
  @visibleForTesting
  // ignore: diagnostic_describe_all_properties
  late final ProviderContainer container;
  ProviderContainer? _debugParentOwner;
  var _dirty = false;

  @override
  void initState() {
    super.initState();

    final parent = _getParent();
    assert(
      () {
        _debugParentOwner = parent;
        return true;
      }(),
      '',
    );

    container = ProviderContainer(
      parent: parent,
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

  ProviderContainer? _getParent() {
    if (widget.parent != null) {
      return widget.parent;
    } else {
      final scope = context
          .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
          ?.widget as UncontrolledProviderScope?;

      return scope?.container;
    }
  }

  @override
  void didUpdateWidget(ProviderScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dirty = true;

    if (oldWidget.parent != widget.parent) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'flutter_riverpod',
          exception: UnsupportedError(
            'Changing ProviderScope.parent is not supported',
          ),
          context: ErrorDescription('while rebuilding ProviderScope'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      () {
        if (widget.parent != null) {
          // didUpdateWidget already takes care of widget.parent change
          return true;
        }
        final parent = _getParent();

        if (parent != _debugParentOwner) {
          throw UnsupportedError(
            'ProviderScope was rebuilt with a different ProviderScope ancestor',
          );
        }
        return true;
      }(),
      '',
    );
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
/// This is what makes `ref.watch(`/`Consumer`/`ref.read` work.
/// {@endtemplate}
@sealed
class UncontrolledProviderScope extends InheritedWidget {
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
  void reassemble() {
    super.reassemble();
    assert(
      () {
        _containerOf(widget).debugReassemble();
        return true;
      }(),
      '',
    );
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

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.transientCallbacks) {
      markNeedsBuild();
    } else {
      // Using microtask, otherwise Flutter tests complain about pending timers
      Future.microtask(() {
        if (_mounted) markNeedsBuild();
      });
    }
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
