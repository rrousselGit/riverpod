import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/src/service/isolate_manager.dart'
    show TestIsolateManager;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/connection.dart';
import 'package:vm_service/vm_service.dart';

class _Service implements VmService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _Isolates with TestIsolateManager {
  @override
  final ValueNotifier<IsolateRef?> selectedIsolate = ValueNotifier<IsolateRef?>(
    IsolateRef(id: 'isolates/1', number: '1', name: 'main'),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// DevTools offers no fake whose connection state can be controlled.
// ignore: subtype_of_sealed_class
class _Manager implements ServiceManager<VmService> {
  @override
  final ValueNotifier<ConnectedState> connectedState = ValueNotifier(
    const ConnectedState(true),
  );
  @override
  final _Isolates isolateManager = _Isolates();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DevtoolsAppConnection', () {
    late _Manager manager;
    late DevtoolsAppConnection connection;
    setUp(() {
      manager = _Manager();
      connection = DevtoolsAppConnection(
        service: _Service(),
        serviceManager: manager,
      );
    });
    tearDown(() {
      manager.connectedState.dispose();
      manager.isolateManager.selectedIsolate.dispose();
    });

    test('exposes the isolate selected in DevTools', () {
      expect(connection.isolate?.id, 'isolates/1');

      manager.isolateManager.selectedIsolate.value = null;

      expect(connection.isolate, isNull);
    });

    test('follows the connection state of DevTools', () {
      expect(connection.connected, isTrue);

      manager.connectedState.value = const ConnectedState(false);

      expect(connection.connected, isFalse);
    });

    test('notifies of isolate and connection changes until removed', () {
      var calls = 0;
      void listener() => calls++;
      connection.addListener(listener);

      manager.isolateManager.selectedIsolate.value = IsolateRef(
        id: 'isolates/2',
      );
      expect(calls, 1);
      manager.connectedState.value = const ConnectedState(false);
      expect(calls, 2);

      connection.removeListener(listener);
      manager.isolateManager.selectedIsolate.value = null;
      manager.connectedState.value = const ConnectedState(true);
      expect(calls, 2);
    });
  });
}
