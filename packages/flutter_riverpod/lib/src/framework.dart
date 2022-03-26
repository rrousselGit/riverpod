import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide describeIdentity;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'internals.dart';

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
    Key? key,
    this.overrides = const [],
    this.observers,
    this.cacheTime,
    this.disposeDelay,
    this.parent,
    this.restorationId,
    this.restorables = const [],
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
      scope = context.getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()?.widget
          as UncontrolledProviderScope?;
    }

    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    return scope.container;
  }

  /// The minimum amount of time before an `autoDispose` provider can be
  /// disposed if not listened.
  ///
  /// If the provider rebuilds (such as when using `ref.watch` or `ref.refresh`),
  /// the timer will be refreshed.
  ///
  /// If null, use the nearest ancestor [ProviderScope]'s [cacheTime].
  /// If no ancestor is found, fallbacks to [Duration.zero].
  final Duration? cacheTime;

  /// The amount of time before a provider is disposed after its last listener
  /// is removed.
  ///
  /// If a new listener is added within that duration, the provider will not be
  /// disposed.
  ///
  /// If null, use the nearest ancestor [ProviderContainer]'s [disposeDelay].
  /// If no ancestor is found, fallbacks to [Duration.zero].
  final Duration? disposeDelay;

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

  /// Informations on how to override a provider/family.
  final List<Override> overrides;

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String? restorationId;

  /// Registers global [RestorableProvider]s for restoration.
  final List<RestorableRestorationId> restorables;

  @override
  ProviderScopeState createState() => ProviderScopeState();
}

/// Do not use: The [State] of [ProviderScope]
@visibleForTesting
@sealed
class ProviderScopeState extends State<ProviderScope> with RestorationMixin implements ProviderObserver {
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
    assert(() {
      _debugParentOwner = parent;
      return true;
    }(), '');

    container = ProviderContainer(
      parent: parent,
      overrides: widget.overrides,
      observers: [
        ...?widget.observers,
        if (widget.restorables.isNotEmpty) this,
      ],
      cacheTime: widget.cacheTime,
      disposeDelay: widget.disposeDelay,
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
    assert(() {
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
    }(), '');
    if (_dirty) {
      _dirty = false;
      container.updateOverrides(widget.overrides);
    }

    // Watch for changes to overidden RestorableProvider
    // Not sure if nessisary
    for (final override in widget.overrides) {
      if (override is RestorableProviderOverride) {
        container.listen<RestorableProperty?>(override.override, (prev, next) {
          if (identical(prev, next)) return;
          if (prev != null) unregisterFromRestoration(prev);
          if (next != null) registerForRestoration(next, override.restorationId);
        });
      }
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

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    for (final override in widget.overrides) {
      if (override is RestorableProviderOverride) {
        final value = container.read(override.override);
        if (value is RestorableProperty) {
          registerForRestoration(value, override.restorationId);
        }
      }
    }
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    final restorationId = _providerRestorationId(provider, container);
    if (restorationId == null) return;

    if (value is RestorableProperty) {
      registerForRestoration(value, restorationId);
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (identical(previousValue, newValue)) return;

    final restorationId = _providerRestorationId(provider, container);
    if (restorationId == null) return;

    if (previousValue is RestorableProperty) {
      unregisterFromRestoration(previousValue);
    }
    if (newValue is RestorableProperty) {
      registerForRestoration(newValue, restorationId);
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    final restorationId = _providerRestorationId(provider, container);
    if (restorationId == null) return;

    if (value is RestorableProperty) {
      unregisterFromRestoration(value);
    }
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {}

  String? _providerRestorationId(ProviderBase provider, ProviderContainer container) {
    // Only look for providers for this container.
    // We only care about providers that implement OverrideWithProviderMixin
    if (container != this.container || provider is! OverrideWithProviderMixin) {
      return null;
    }

    return widget.restorables
        .firstWhereOrNull((e) => identical(e.provider, provider.from ?? provider))
        ?.restorationIdFromArg(provider.argument);
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
  // ignore: library_private_types_in_public_api
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

    // ignore: unnecessary_non_null_assertion, blocked by https://github.com/rrousselGit/river_pod/issues/1156
    if (SchedulerBinding.instance!.schedulerPhase ==
        SchedulerPhase.transientCallbacks) {
      markNeedsBuild();
    } else {
      // Using microtask as Flutter otherwise Flutter tests omplains about pending timers
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
