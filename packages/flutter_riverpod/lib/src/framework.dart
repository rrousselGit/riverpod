// ignore_for_file: invalid_use_of_internal_member, deprecated_member_use_from_same_package

import 'package:flutter/foundation.dart' hide describeIdentity;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'internals.dart';

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
@sealed
class ProviderScope extends StatefulWidget {
  /// {@macro riverpod.provider_scope}
  const ProviderScope({
    super.key,
    this.overrides = const [],
    this.observers,
    @Deprecated(
      'Will be removed in 3.0.0. See https://github.com/rrousselGit/riverpod/issues/3261#issuecomment-1973514033',
    )
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
  @Deprecated(
    'Will be removed in 3.0.0. See https://github.com/rrousselGit/riverpod/issues/3261#issuecomment-1973514033',
  )
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
      debugCanModifyProviders ??= _debugCanModifyProviders;
    }

    _containerOf(widget).scheduler.flutterVsyncs.add(_flutterVsync);
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
    _mounted = false;
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
