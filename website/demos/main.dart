import 'dart:js_interop';
import 'dart:ui' show FlutterView;
import 'dart:ui_web' as ui_web;

import 'package:material_ui/material_ui.dart';
import 'package:web/web.dart' as web;

import 'bridge.dart';
import 'pull_to_refresh.dart';

/// The demos that can be embedded in the website, keyed by the `demo` value
/// passed as `initialData` when the page adds a view.
final demos = <String, Widget Function(DemoBridge bridge)>{
  'pull_to_refresh': (bridge) => PullToRefreshDemo(bridge: bridge),
};

/// Runs in multi-view mode: the website adds one view per embedded demo,
/// so that a single engine serves every demo on the page.
void main() => runWidget(const DemoViews());

class DemoViews extends StatefulWidget {
  const DemoViews({super.key});

  @override
  State<DemoViews> createState() => _DemoViewsState();
}

class _DemoViewsState extends State<DemoViews> with WidgetsBindingObserver {
  Iterable<FlutterView> get _views =>
      WidgetsBinding.instance.platformDispatcher.views;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Called when views are added or removed.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(
      views: [
        for (final view in _views)
          View(
            key: ValueKey(view.viewId),
            view: view,
            child: _DemoView(viewId: view.viewId),
          ),
      ],
    );
  }
}

class _DemoView extends StatefulWidget {
  const _DemoView({required this.viewId});

  final int viewId;

  @override
  State<_DemoView> createState() => _DemoViewState();
}

class _DemoViewState extends State<_DemoView> {
  late final DemoBridge bridge;
  late final String? demoName;

  @override
  void initState() {
    super.initState();
    final host = ui_web.views.getHostElement(widget.viewId)! as web.Element;
    bridge = DemoBridge(host);

    final initialData = ui_web.views.getInitialData(widget.viewId).dartify();
    demoName = initialData is Map ? initialData['demo'] as String? : null;

    // Demos start listening to commands when first built, so tell the page
    // once that is done.
    WidgetsBinding.instance.addPostFrameCallback((_) => bridge.emit('ready'));
  }

  @override
  void dispose() {
    bridge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builder = demos[demoName];
    if (builder == null) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: Text('Unknown demo: $demoName')),
      );
    }

    return builder(bridge);
  }
}
