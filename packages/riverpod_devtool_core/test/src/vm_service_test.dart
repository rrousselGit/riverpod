import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/src/connection.dart';
import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart' as vm;

import '../utils.dart';

class _FakeVmService implements vm.VmService {
  _FakeVmService(this._events, {Stream<vm.Event>? isolateEvents})
    : _isolateEvents = isolateEvents ?? const Stream.empty();

  final Stream<vm.Event> _events;
  final Stream<vm.Event> _isolateEvents;

  @override
  Stream<vm.Event> get onExtensionEvent => _events;

  @override
  Stream<vm.Event> get onIsolateEvent => _isolateEvents;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('decodeAll', () {
    test('decodes values using indexed paths', () {
      final events = <String, VmInstanceRef>{
        'root.length': VmInstanceRef.int(2, id: 'ref-2'),
        'root[0]': VmInstanceRef.string('alpha', id: 'ref-alpha'),
        'root[1]': VmInstanceRef.string('beta', id: 'ref-beta'),
      };

      final result = decodeAll<String>(
        events,
        (map, {required path}) => map[path]!.valueAsString!,
        path: 'root',
      ).toList();

      expect(result, ['alpha', 'beta']);
    });
  });

  test('decoding rejects values of another type', () {
    expect(
      () => Frame.from({
        'root._type': VmInstanceRef.string('ProviderMeta'),
      }, path: 'root'),
      throwsA(
        isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Invalid event type, expected "Frame" but got ProviderMeta',
        ),
      ),
    );
  });

  group('encodeList', () {
    test('generates code that maps list items by index', () {
      final code = encodeList(
        'myList',
        (name, path) => "{'$path': $name}",
        path: 'root',
      );

      expect(code, contains("'root.length': list.length"));
      expect(code, contains('for (final (index, e) in list.indexed)'));
      expect(code, contains(r"'root[$index]'"));
    });
  });

  group('NotificationService.onNotification', () {
    test(
      'maps recognized extension events to Riverpod notifications',
      () async {
        final extensionData = vm.ExtensionData()..data['offset'] = 7;
        final connection = FakeConnection(
          _FakeVmService(
            Stream.value(
              vm.Event(
                kind: vm.EventKind.kExtension,
                isolate: vm.IsolateRef(id: 'isolates/1'),
                extensionKind: 'riverpod:new_event',
                extensionData: extensionData,
              ),
            ),
          ),
        );

        final notifications = await connection.onNotification.toList();

        expect(notifications, hasLength(1));
        expect(notifications.single.name, 'riverpod:new_event');
        expect(notifications.single.toJson(), {'offset': 7});
      },
    );

    test('ignores unrelated extension events', () async {
      final isolate = vm.IsolateRef(id: 'isolates/1');
      final connection = FakeConnection(
        _FakeVmService(
          Stream.fromIterable([
            vm.Event(
              kind: vm.EventKind.kExtension,
              isolate: isolate,
              extensionKind: 'not-riverpod',
              extensionData: vm.ExtensionData(),
            ),
            vm.Event(kind: vm.EventKind.kExtension, isolate: isolate),
          ]),
        ),
      );

      expect(await connection.onNotification.toList(), isEmpty);
    });

    test('ignores the notifications of other isolates', () async {
      vm.Event event(String isolateId, int offset) => vm.Event(
        kind: vm.EventKind.kExtension,
        isolate: vm.IsolateRef(id: isolateId),
        extensionKind: 'riverpod:new_event',
        extensionData: vm.ExtensionData()..data['offset'] = offset,
      );
      final connection = FakeConnection(
        _FakeVmService(
          Stream.fromIterable([
            event('isolates/2', 1),
            event('isolates/1', 2),
            vm.Event(
              kind: vm.EventKind.kExtension,
              extensionKind: 'riverpod:new_event',
              extensionData: vm.ExtensionData()..data['offset'] = 3,
            ),
          ]),
        ),
      );

      final notifications = await connection.onNotification.toList();

      expect(notifications.map((e) => e.toJson()), [
        {'offset': 2},
      ]);
    });
  });

  group('hotRestartEventProvider', () {
    test('notifies once the isolate of the application is replaced', () async {
      final connection = FakeConnection(_FakeVmService(const Stream.empty()));
      final container = ProviderContainer.test(
        overrides: [appConnectionProvider.overrideWith((ref) => connection)],
      );
      var restarts = 0;
      container.listen(hotRestartEventProvider, (_, _) => restarts++);
      await container.read(appConnectionProvider.future);
      await pumpEventQueue();

      // The isolate goes away during the restart, before its successor starts.
      // Nothing can be read from the application until then.
      connection.isolate = null;
      expect(restarts, 0);
      connection.isolate = vm.IsolateRef(id: 'isolates/2');
      expect(restarts, 1);

      connection.isolate = vm.IsolateRef(id: 'isolates/3');
      expect(restarts, 2);

      connection.isolate = vm.IsolateRef(id: 'isolates/3');
      expect(restarts, 2);

      // The restart is aborted, and the application keeps its isolate.
      connection.isolate = null;
      connection.isolate = vm.IsolateRef(id: 'isolates/3');
      expect(restarts, 2);

      container.dispose();
      expect(connection.hasListeners, isFalse);
    });

    test('notifies of the first isolate of the application', () async {
      final connection = FakeConnection(_FakeVmService(const Stream.empty()))
        ..isolate = null;
      final container = ProviderContainer.test(
        overrides: [appConnectionProvider.overrideWith((ref) => connection)],
      );
      var restarts = 0;
      container.listen(hotRestartEventProvider, (_, _) => restarts++);
      await container.read(appConnectionProvider.future);
      await pumpEventQueue();

      // What failed to be read without an isolate can be read again.
      connection.isolate = vm.IsolateRef(id: 'isolates/1');
      expect(restarts, 1);
    });
  });

  group('hotReloadEventProvider', () {
    test('notifies when the isolate of the application is reloaded', () async {
      final events = StreamController<vm.Event>(sync: true);
      addTearDown(events.close);
      final connection = FakeConnection(
        _FakeVmService(const Stream.empty(), isolateEvents: events.stream),
        isolate: vm.IsolateRef(
          id: 'isolates/1',
          isolateGroupId: 'isolateGroups/1',
        ),
      );
      final container = ProviderContainer.test(
        overrides: [appConnectionProvider.overrideWith((ref) => connection)],
      );
      var reloads = 0;
      container.listen(hotReloadEventProvider, (_, _) => reloads++);
      await container.read(appConnectionProvider.future);
      await pumpEventQueue();

      // The VM reports the group that it reloaded.
      events.add(
        vm.Event(
          kind: vm.EventKind.kIsolateReload,
          isolateGroup: vm.IsolateGroupRef(id: 'isolateGroups/1'),
        ),
      );
      expect(reloads, 1);

      events.add(
        vm.Event(
          kind: vm.EventKind.kIsolateReload,
          isolate: vm.IsolateRef(id: 'isolates/1'),
        ),
      );
      expect(reloads, 2);

      // Other isolates, and other events of the isolate, are ignored.
      events
        ..add(
          vm.Event(
            kind: vm.EventKind.kIsolateReload,
            isolateGroup: vm.IsolateGroupRef(id: 'isolateGroups/2'),
          ),
        )
        ..add(
          vm.Event(
            kind: vm.EventKind.kIsolateReload,
            isolate: vm.IsolateRef(id: 'isolates/2'),
            isolateGroup: vm.IsolateGroupRef(id: 'isolateGroups/1'),
          ),
        )
        ..add(
          vm.Event(
            kind: vm.EventKind.kIsolateUpdate,
            isolate: vm.IsolateRef(id: 'isolates/1'),
          ),
        );
      expect(reloads, 2);

      container.dispose();
      expect(events.hasListener, isFalse);
    });
  });
}
