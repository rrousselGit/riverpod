import 'package:flutter/foundation.dart' hide describeIdentity;
import 'package:flutter/widgets.dart';
import 'package:riverpod/riverpod.dart';
import 'package:meta/meta.dart';

import 'internals.dart' show describeIdentity;

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
///               themeProvider.overrideWithProvider(
///                 Provider((_) => MyTheme.dark()),
///               ),
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
    Key key,
    this.overrides = const [],
    this.observers,
    @required this.child,
  })  : assert(child != null, 'child cannot be `null`'),
        super(key: key);

  /// Read the current [ProviderContainer] for a [BuildContext].
  static ProviderContainer containerOf(
    BuildContext context, {
    bool listen = true,
  }) {
    UncontrolledProviderScope scope;

    if (listen) {
      scope = context //
          .dependOnInheritedWidgetOfExactType<UncontrolledProviderScope>();
    } else {
      scope = context
          .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
          .widget as UncontrolledProviderScope;
    }

    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    return scope.container;
  }

  /// The part of the widget tree that can use Riverpod and has overridden providers.
  final Widget child;

  /// The listeners that subscribes to changes on providers stored on this [ProviderScope].
  final List<ProviderObserver> observers;

  /// Informations on how to override a provider/family.
  final List<Override> overrides;

  @override
  ProviderScopeState createState() => ProviderScopeState();

  @override
  _ProviderScopeElement createElement() {
    return _ProviderScopeElement(this);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ProviderObserver>('observers', observers));
    properties.add(IterableProperty<Override>('overrides', overrides));
  }
}

@sealed
class _ProviderScopeElement extends StatefulElement {
  _ProviderScopeElement(ProviderScope widget) : super(widget);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final container = (state as ProviderScopeState).container;

    // filling the state properties here instead of inside State
    // so that it is more readable in the devtool (one less indentation)
    for (final entry in container.debugProviderValues.entries) {
      final name = entry.key.name ?? describeIdentity(entry.key);
      properties.add(DiagnosticsProperty(name, entry.value));
    }
  }
}

/// Do not use: The [State] of [ProviderScope]
@visibleForTesting
@sealed
class ProviderScopeState extends State<ProviderScope> {
  /// The [ProviderContainer] exposed to [ProviderScope.child].
  @visibleForTesting
  // ignore: diagnostic_describe_all_properties
  ProviderContainer container;
  ProviderContainer _debugParentOwner;
  var _dirty = false;

  @override
  void initState() {
    super.initState();
    final scope = context
        .getElementForInheritedWidgetOfExactType<UncontrolledProviderScope>()
        ?.widget as UncontrolledProviderScope;

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
          ?.widget as UncontrolledProviderScope;

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
/// This is what makes `useProvider`/`Consumer`/`context.read` work.
/// {@endtemplate}
@sealed
class UncontrolledProviderScope extends InheritedWidget {
  /// {@macro riverpod.UncontrolledProviderScope}
  const UncontrolledProviderScope({
    Key key,
    @required this.container,
    @required Widget child,
  })  : assert(container != null, 'ProviderContainer cannot be null'),
        super(key: key, child: child);

  /// The [ProviderContainer] exposed to the widget tree.
  final ProviderContainer container;

  @override
  bool updateShouldNotify(UncontrolledProviderScope oldWidget) {
    return container != oldWidget.container;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (final entry in container.debugProviderValues.entries) {
      final name = entry.key.name ?? describeIdentity(entry.key);
      properties.add(DiagnosticsProperty(name, entry.value));
    }
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

  @override
  void mount(Element parent, dynamic newSlot) {
    assert(() {
      (widget as UncontrolledProviderScope)
          .container
          .debugVsyncs
          .add(markNeedsBuild);
      return true;
    }(), '');
    super.mount(parent, newSlot);
  }

  @override
  void update(ProxyWidget newWidget) {
    assert(() {
      (widget as UncontrolledProviderScope)
          .container
          .debugVsyncs
          .remove(markNeedsBuild);
      (newWidget as UncontrolledProviderScope)
          .container
          .debugVsyncs
          .add(markNeedsBuild);
      return true;
    }(), '');
    super.update(newWidget);
  }

  @override
  void unmount() {
    assert(() {
      (widget as UncontrolledProviderScope)
          .container
          .debugVsyncs
          .remove(markNeedsBuild);
      return true;
    }(), '');
    super.unmount();
  }
}
