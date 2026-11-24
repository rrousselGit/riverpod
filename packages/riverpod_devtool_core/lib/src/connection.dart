import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vm_service/vm_service.dart';

/// The running application that the devtool inspects.
///
/// This is all that the devtool needs from its host. DevTools implements it
/// from its service manager, and [VmServiceConnection] from a bare
/// [VmService].
abstract class AppConnection {
  /// The VM service of the application.
  VmService get service;

  /// The isolate in which Riverpod runs, or `null` while there is none, such
  /// as during a hot-restart.
  IsolateRef? get isolate;

  /// Whether [service] is still connected to the application.
  bool get connected;

  /// Listens to changes of [isolate] and [connected].
  void addListener(void Function() listener);

  /// Stops listening to changes of [isolate] and [connected].
  void removeListener(void Function() listener);
}

/// The application that every other provider talks to.
///
/// Has to be overridden with how the host connects to the application.
final appConnectionProvider = FutureProvider<AppConnection>(
  name: 'appConnectionProvider',
  (ref) => throw UnimplementedError(
    'appConnectionProvider must be overridden with the connection to the '
    'application.',
  ),
);

/// An [AppConnection] for a [VmService] that nothing else manages.
///
/// It follows the main isolate of the application across hot-restarts.
class VmServiceConnection implements AppConnection {
  VmServiceConnection._(this.service);

  /// Subscribes to the events that the devtool needs, and selects the isolate
  /// of the application.
  ///
  /// The connection owns [service], and closes it if it fails to start.
  static Future<VmServiceConnection> start(VmService service) async {
    final connection = VmServiceConnection._(service);
    connection._isolateEvents = service.onIsolateEvent.listen(
      connection._onIsolateEvent,
    );
    unawaited(
      service.onDone.then((_) {
        connection._connected = false;
        connection._set(null);
      }),
    );
    try {
      await Future.wait([
        for (final stream in [EventStreams.kIsolate, EventStreams.kExtension])
          service
              .streamListen(stream)
              .then<void>((_) {})
              .catchError(
                // Another client of this VmService may have subscribed already.
                (Object _) {},
                test: (error) =>
                    error is RPCError &&
                    error.code == RPCErrorKind.kStreamAlreadySubscribed.code,
              ),
      ]);
      await connection._selectIsolate();
    } catch (_) {
      // Nobody else can close the service of a connection that never started.
      await connection.dispose();
      rethrow;
    }
    return connection;
  }

  @override
  final VmService service;

  final _listeners = <void Function()>[];
  late final StreamSubscription<Event> _isolateEvents;

  @override
  IsolateRef? get isolate => _isolate;
  IsolateRef? _isolate;

  @override
  bool get connected => _connected;
  bool _connected = true;

  Future<void> _selectIsolate() async {
    final isolates = (await service.getVM()).isolates ?? const <IsolateRef>[];
    final candidate =
        isolates.firstWhereOrNull((isolate) => isolate.name == 'main') ??
        isolates.firstOrNull;
    // An event may have selected an isolate while waiting for the VM.
    if (_shouldSelect(candidate)) _set(candidate);
  }

  /// Whether [candidate] is a better choice than the selected isolate.
  ///
  /// Riverpod runs in the main isolate. Others are only selected until the
  /// main one is there.
  bool _shouldSelect(IsolateRef? candidate) {
    if (candidate == null || !_connected) return false;
    if (_isolate case final isolate?) {
      return candidate.name == 'main' && isolate.name != 'main';
    }
    return true;
  }

  void _onIsolateEvent(Event event) {
    switch (event.kind) {
      case EventKind.kIsolateRunnable when _shouldSelect(event.isolate):
        _set(event.isolate);
      case EventKind.kIsolateExit when event.isolate?.id == _isolate?.id:
        _set(null);
        // Another isolate may have become runnable before this one exited.
        unawaited(_selectIsolate().catchError((Object _) {}));
    }
  }

  void _set(IsolateRef? isolate) {
    _isolate = isolate;
    for (final listener in _listeners.toList()) {
      listener();
    }
  }

  @override
  void addListener(void Function() listener) => _listeners.add(listener);

  @override
  void removeListener(void Function() listener) => _listeners.remove(listener);

  /// Stops following the application and closes [service].
  Future<void> dispose() async {
    await _isolateEvents.cancel();
    await service.dispose();
  }
}
