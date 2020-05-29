import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod/riverpod.dart';

import 'internal.dart';

class ProviderScope extends StatefulWidget {
  const ProviderScope({
    Key key,
    this.overrides = const [],
    @required this.child,
  })  : assert(child != null, 'child cannot be `null`'),
        super(key: key);

  @visibleForTesting
  final Widget child;

  @visibleForTesting
  final List<ProviderOverride> overrides;

  @override
  _ProviderScopeState createState() => _ProviderScopeState();

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
    final owner = (state as _ProviderScopeState)._owner;

    // filling the state properties here instead of inside State
    // so that it is more readable in the devtool (one less indentation)
    for (final entry in owner.debugProviderStates.entries) {
      final name = entry.key.name ?? describeIdentity(entry.key);
      properties.add(DiagnosticsProperty(name, entry.value));
    }
  }
}

class _ProviderScopeState extends State<ProviderScope> {
  ProviderStateOwner _owner;
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

    _owner = ProviderStateOwner(
      parent: scope?.owner,
      overrides: widget.overrides,
      markNeedsUpdate: () => setState(() => _dirty = true),
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
    _owner.update(widget.overrides);
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
      return true;
    }(), '');
    if (_dirty) {
      _dirty = false;
      _owner.update();
    }
    return ProviderStateOwnerScope(
      owner: _owner,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _owner.dispose();
    super.dispose();
  }
}

class ProviderStateOwnerScope extends InheritedWidget {
  const ProviderStateOwnerScope({
    Key key,
    @required this.owner,
    Widget child,
  })  : assert(owner != null, 'ProviderStateOwner cannot be null'),
        super(key: key, child: child);

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

  final ProviderStateOwner owner;

  @override
  bool updateShouldNotify(ProviderStateOwnerScope oldWidget) {
    return owner != oldWidget.owner;
  }
}
