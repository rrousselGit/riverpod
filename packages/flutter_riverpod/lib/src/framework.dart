import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod/riverpod.dart';

import 'internals.dart';

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
///         repositoryProvider.overrideAs(
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
///               themeProvider.overrideAs(
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
class ProviderScope extends StatefulWidget {
  /// Enabled Riverpod for part of the application and optionally allows overriding
  /// the behavior of a provider.
  const ProviderScope({
    Key key,
    this.overrides = const [],
    this.observers,
    @required this.child,
  })  : assert(child != null, 'child cannot be `null`'),
        super(key: key);

  /// The part of the widget tree that can use Riverpod and has overriden providers.
  final Widget child;

  /// The listeners that subscribes to changes on providers stored on this [ProviderScope].
  final List<ProviderStateOwnerObserver> observers;

  /// Informations on how to override a provider/family.
  final List<Override> overrides;

  @override
  ProviderScopeState createState() => ProviderScopeState();

  @override
  _ProviderScopeElement createElement() {
    return _ProviderScopeElement(this);
  }
}

class _ProviderScopeElement extends StatefulElement {
  _ProviderScopeElement(ProviderScope widget) : super(widget);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final owner = (state as ProviderScopeState).owner;

    // filling the state properties here instead of inside State
    // so that it is more readable in the devtool (one less indentation)
    for (final entry in owner.debugProviderValues.entries) {
      final name = entry.key.name ?? describeIdentity(entry.key);
      properties.add(DiagnosticsProperty(name, entry.value));
    }
  }
}

/// Do not use: The [State] of [ProviderScope]
@visibleForTesting
class ProviderScopeState extends State<ProviderScope> {
  /// The [ProviderStateOwner] exposed to [ProviderScope.child].
  @visibleForTesting
  ProviderStateOwner owner;
  ProviderStateOwner _debugParentOwner;
  var _dirty = false;

  @override
  void initState() {
    super.initState();
    final scope = context
        .getElementForInheritedWidgetOfExactType<ProviderStateOwnerScope>()
        ?.widget as ProviderStateOwnerScope;

    assert(() {
      _debugParentOwner = scope?.owner;
      return true;
    }(), '');

    owner = ProviderStateOwner(
      parent: scope?.owner,
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
          .getElementForInheritedWidgetOfExactType<ProviderStateOwnerScope>()
          ?.widget as ProviderStateOwnerScope;

      if (scope?.owner != _debugParentOwner) {
        throw UnsupportedError(
          'ProviderScope was rebuilt with a different ProviderScope ancestor',
        );
      }
      if (_dirty) {
        _dirty = false;
        owner.updateOverrides(widget.overrides);
      }
      return true;
    }(), '');

    return ProviderStateOwnerScope(
      owner: owner,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    owner.dispose();
    super.dispose();
  }
}

/// An internal InheritedWidget that exposes a [ProviderStateOwner] to the widget tree.
class ProviderStateOwnerScope extends InheritedWidget {
  /// Exposes a [ProviderStateOwner] to the widget tree
  const ProviderStateOwnerScope({
    Key key,
    @required this.owner,
    Widget child,
  })  : assert(owner != null, 'ProviderStateOwner cannot be null'),
        super(key: key, child: child);

  /// Read the current [ProviderStateOwner] for a [BuildContext].
  static ProviderStateOwner of(BuildContext context, {bool listen = true}) {
    ProviderStateOwnerScope scope;

    if (listen) {
      scope = context //
          .dependOnInheritedWidgetOfExactType<ProviderStateOwnerScope>();
    } else {
      scope = context
          .getElementForInheritedWidgetOfExactType<ProviderStateOwnerScope>()
          .widget as ProviderStateOwnerScope;
    }

    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    return scope.owner;
  }

  /// The [ProviderStateOwner] exposes to the widget tree.
  final ProviderStateOwner owner;

  @override
  bool updateShouldNotify(ProviderStateOwnerScope oldWidget) {
    return owner != oldWidget.owner;
  }
}
