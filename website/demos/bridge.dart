import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The event type the page dispatches on a view's host element to control a demo.
///
/// Its `detail` is `{type: string, value?: any}`.
const commandEventType = 'riverpod-demo:command';

/// The event type a demo dispatches on its host element to report to the page.
///
/// Its `detail` is `{type: string, data?: any}`.
const reportEventType = 'riverpod-demo:event';

/// A two-way channel between a demo and the page embedding it,
/// implemented as DOM events on the view's host element.
///
/// This keeps the page and the Flutter app decoupled: the page only needs
/// the host element it created, and never touches Dart objects.
class DemoBridge {
  DemoBridge(this._host);

  final web.EventTarget _host;
  final _listeners = <JSFunction>[];

  /// Calls [onCommand] whenever the page sends a command to this demo.
  void listen(void Function(String type, Object? value) onCommand) {
    final listener = (web.Event event) {
      final detail = (event as web.CustomEvent).detail.dartify();
      if (detail is! Map) return;
      final type = detail['type'];
      if (type is! String) return;
      onCommand(type, detail['value']);
    }.toJS;

    _listeners.add(listener);
    _host.addEventListener(commandEventType, listener);
  }

  /// Sends a report to the page.
  void emit(String type, [Object? data]) {
    _host.dispatchEvent(
      web.CustomEvent(
        reportEventType,
        web.CustomEventInit(detail: {'type': type, 'data': data}.jsify()),
      ),
    );
  }

  void dispose() {
    for (final listener in _listeners) {
      _host.removeEventListener(commandEventType, listener);
    }
    _listeners.clear();
  }
}
