import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/src/connection.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';

import '../utils.dart';

class _Service implements VmService {
  final isolateEvents = StreamController<Event>.broadcast(sync: true);
  final done = Completer<void>();
  List<IsolateRef> isolates = [
    IsolateRef(id: 'isolates/worker', name: 'worker'),
    IsolateRef(id: 'isolates/main', name: 'main'),
  ];
  final listened = <String>[];
  RPCError? listenError;
  bool disposed = false;

  @override
  Stream<Event> get onIsolateEvent => isolateEvents.stream;

  @override
  Future<void> get onDone => done.future;

  @override
  Future<Success> streamListen(String streamId) async {
    listened.add(streamId);
    if (listenError case final error?) throw error;
    return Success();
  }

  @override
  Future<VM> getVM() async => VM(isolates: isolates);

  @override
  Future<void> dispose() async => disposed = true;

  Future<void> close() => isolateEvents.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('appConnectionProvider has to be overridden', () async {
    final container = ProviderContainer.test();

    await expectLater(
      container.read(appConnectionProvider.future),
      throwsA(isA<UnimplementedError>()),
    );
  });

  group('VmServiceConnection', () {
    late _Service service;
    setUp(() => service = _Service());
    tearDown(() => service.close());

    test('subscribes to the streams that the devtool reads', () async {
      await VmServiceConnection.start(service);

      expect(service.listened, [
        EventStreams.kIsolate,
        EventStreams.kExtension,
      ]);
    });

    test('accepts streams that another client subscribed to', () async {
      service.listenError = RPCError(
        'streamListen',
        RPCErrorKind.kStreamAlreadySubscribed.code,
        'Stream already subscribed',
      );

      final connection = await VmServiceConnection.start(service);

      expect(connection.isolate?.id, 'isolates/main');
    });

    test('fails to start when streams cannot be listened to', () async {
      final error = service.listenError = RPCError('streamListen', 100, 'no');

      await expectLater(VmServiceConnection.start(service), throwsA(error));
    });

    test('selects the main isolate, or else the first one', () async {
      expect(
        (await VmServiceConnection.start(service)).isolate?.id,
        'isolates/main',
      );

      service.isolates = [IsolateRef(id: 'isolates/a', name: 'a')];
      expect(
        (await VmServiceConnection.start(service)).isolate?.id,
        'isolates/a',
      );

      service.isolates = [];
      expect((await VmServiceConnection.start(service)).isolate, isNull);
    });

    test('follows the application across a hot-restart', () async {
      final connection = await VmServiceConnection.start(service);
      final isolates = <String?>[];
      void listener() => isolates.add(connection.isolate?.id);
      connection.addListener(listener);
      final restarted = IsolateRef(id: 'isolates/restarted', name: 'main');

      // Other isolates coming and going do not affect the selection.
      service.isolateEvents.add(
        Event(kind: EventKind.kIsolateExit, isolate: service.isolates.first),
      );
      service.isolateEvents.add(
        Event(kind: EventKind.kIsolateRunnable, isolate: restarted),
      );
      expect(isolates, isEmpty);

      service.isolates = [];
      service.isolateEvents.add(
        Event(kind: EventKind.kIsolateExit, isolate: connection.isolate),
      );
      expect(isolates, [null]);

      service.isolateEvents.add(
        Event(kind: EventKind.kIsolateRunnable, isolate: restarted),
      );
      expect(isolates, [null, 'isolates/restarted']);

      connection.removeListener(listener);
      service.isolateEvents.add(
        Event(kind: EventKind.kIsolateExit, isolate: restarted),
      );
      expect(isolates, [null, 'isolates/restarted']);
    });

    test(
      'selects an isolate that started before the previous one exited',
      () async {
        final connection = await VmServiceConnection.start(service);
        final restarted = IsolateRef(id: 'isolates/restarted', name: 'main');
        service.isolates = [restarted];

        service.isolateEvents.add(
          Event(kind: EventKind.kIsolateExit, isolate: connection.isolate),
        );
        await pumpEventQueue();

        expect(connection.isolate?.id, 'isolates/restarted');
      },
    );

    test('has no isolate once the VM service closes', () async {
      final connection = await VmServiceConnection.start(service);
      var notifications = 0;
      connection.addListener(() => notifications++);

      service.done.complete();
      await pumpEventQueue();

      expect(connection.connected, isFalse);
      expect(connection.isolate, isNull);
      expect(notifications, 1);

      // A closed connection does not select isolates anymore.
      service.isolateEvents.add(
        Event(kind: EventKind.kIsolateRunnable, isolate: service.isolates.last),
      );
      expect(connection.isolate, isNull);
    });

    test('dispose closes the VM service', () async {
      final connection = await VmServiceConnection.start(service);

      await connection.dispose();

      expect(service.disposed, isTrue);
      expect(service.isolateEvents.hasListener, isFalse);
    });

    test('connects to a real application', () async {
      final app = await startApp();
      final connection = app.connection;
      var notifications = 0;
      connection.addListener(() => notifications++);

      expect(connection.connected, isTrue);
      expect(connection.isolate?.name, 'main');

      await app.close();

      expect(connection.connected, isFalse);
      expect(connection.isolate, isNull);
      expect(notifications, 1);
    });
  });
}
