import 'dart:async';

import 'package:devtools_app_shared/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_devtool/src/frames.dart';
import 'package:riverpod_devtool/src/vm_service.dart';
import 'package:vm_service/vm_service.dart' as vm;

class _FakeEvalFactory implements EvalFactory {
  @override
  String? sessionId;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SessionEval implements Eval {
  @override
  final factory = _FakeEvalFactory();

  final commands = <String>[];
  int sessions = 0;
  bool valid = true;
  bool failRenewal = false;
  bool expireFetch = false;
  Completer<Byte<VmInstanceRef>>? pendingOpen;
  Completer<Byte<VmInstanceRef>>? pendingRenewal;

  @override
  Future<Byte<VmInstance>> evalInstance(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    commands.add(code);
    if (expireFetch) {
      expireFetch = false;
      return ByteError(const ExpiredDevtoolSessionType());
    }
    // A full baseline export, including a timestamp that changes on reconnect.
    final values = <String, VmInstanceRef>{
      'root.length': VmInstanceRef.int(1),
      'root[0].index': VmInstanceRef.int(0),
      'root[0].timestamp': VmInstanceRef.int(sessions),
      'root[0].events.length': VmInstanceRef.int(0),
    };
    return ByteVariable(
      VmInstance(
        vm.Instance(
          id: 'frames',
          kind: vm.InstanceKind.kMap,
          associations: [
            for (final entry in values.entries)
              vm.MapAssociation(
                key: VmInstanceRef.string(entry.key).raw,
                value: entry.value.raw,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Future<Byte<VmInstanceRef>> eval(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    commands.add(code);
    if (code.endsWith('openSession()')) {
      if (pendingOpen case final pending?) return pending.future;
      return ByteVariable(VmInstanceRef.string('session-${++sessions}'));
    }
    if (code.contains('renewSession')) {
      if (pendingRenewal case final pending?) return pending.future;
      if (failRenewal) throw StateError('disconnected');
      return ByteVariable(VmInstance.bool(value: valid).ref);
    }
    return ByteVariable(VmInstance.null_().ref);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FrameService implements vm.VmService {
  final events = StreamController<vm.Event>.broadcast();

  @override
  Stream<vm.Event> get onExtensionEvent => events.stream;

  void notify() => events.add(
    vm.Event(
      kind: vm.EventKind.kExtension,
      timestamp: 0,
      extensionKind: 'riverpod:new_event',
      extensionData: vm.ExtensionData()..data['offset'] = 0,
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ProviderContainer _container(_SessionEval eval) => ProviderContainer.test(
  overrides: [
    hotRestartEventProvider.overrideWith((ref) {}),
    riverpodEvalProvider.overrideWith((ref) => RiverpodEval(eval)),
  ],
);

void main() {
  testWidgets('frames refresh fully when an export discovers lease expiry', (
    tester,
  ) async {
    final eval = _SessionEval();
    final service = _FrameService();
    final container = ProviderContainer.test(
      overrides: [
        hotRestartEventProvider.overrideWith((ref) {}),
        riverpodEvalProvider.overrideWith((ref) => RiverpodEval(eval)),
        vmServiceProvider.overrideWithBuild((ref, self) => service),
      ],
    );
    container.listen(framesProvider, (_, _) {});
    final initial = await container.read(framesProvider.future);
    expect(initial.single.frame.timestamp.millisecondsSinceEpoch, 1);
    eval.expireFetch = true;
    service.notify();
    await tester.pump();
    final refreshed = await container.read(framesProvider.future);
    expect(eval.factory.sessionId, 'session-2');
    expect(refreshed.single.frame.timestamp.millisecondsSinceEpoch, 2);
    expect(refreshed.single.previous, isNull);
    expect(
      eval.commands.where((code) => code.contains('withFrameCache')).last,
      contains('withFrameCache("session-2"'),
    );
    container.dispose();
    await service.events.close();
    await tester.pump();
  });

  testWidgets('renews an active lease and closes it on disposal', (
    tester,
  ) async {
    final eval = _SessionEval();
    final container = _container(eval);
    final subscription = container.listen(devtoolSessionProvider, (_, _) {});
    expect(await container.read(devtoolSessionProvider.future), 'session-1');
    expect(eval.factory.sessionId, 'session-1');
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    expect(eval.commands.where((code) => code.contains('renewSession')), [
      'RiverpodDevtool.instance.renewSession("session-1")',
    ]);
    container.dispose();
    subscription.close();
    await tester.pump();
    expect(eval.factory.sessionId, isNull);
    expect(
      eval.commands.last,
      'RiverpodDevtool.instance.closeSession("session-1")',
    );
    final commands = [...eval.commands];
    await tester.pump(const Duration(seconds: 30));
    expect(eval.commands, commands);
  });

  testWidgets('idle heartbeats do not refresh state or notifier consumers', (
    tester,
  ) async {
    final eval = _SessionEval();
    final container = _container(eval);
    final builds = <String, int>{};
    final inspector = FutureProvider.family<String, String>((ref, name) async {
      final session = await ref.watch(devtoolSessionProvider.future);
      builds.update(name, (count) => count + 1, ifAbsent: () => 1);
      return session;
    });
    final changes = <String>[];
    for (final name in ['state', 'notifier']) {
      container.listen(
        inspector(name),
        (_, value) => changes.add('$name:$value'),
      );
      expect(await container.read(inspector(name).future), 'session-1');
    }
    changes.clear();
    for (var i = 0; i < 9; i++) {
      await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    }
    expect(builds, {'state': 1, 'notifier': 1});
    expect(changes, isEmpty);
    expect(eval.sessions, 1);
    expect(
      eval.commands.where((code) => code.contains('renewSession')).length,
      9,
    );
    container.dispose();
    await tester.pump();
  });

  testWidgets('an expired lease refreshes consumers with a new session', (
    tester,
  ) async {
    final eval = _SessionEval();
    final container = _container(eval);
    final fetchedSessions = <String>[];
    final snapshot = FutureProvider((ref) async {
      final session = await ref.watch(devtoolSessionProvider.future);
      fetchedSessions.add(session);
      return foldFrames(const [], [Frame.test(index: 0, events: const [])]);
    });
    container.listen(snapshot, (_, _) {});
    await container.read(snapshot.future);
    eval.valid = false;
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    await container.read(snapshot.future);
    expect(fetchedSessions, ['session-1', 'session-2']);
    expect(eval.factory.sessionId, 'session-2');
    expect(
      eval.commands,
      contains('RiverpodDevtool.instance.closeSession("session-1")'),
    );
    container.dispose();
    await tester.pump();
  });

  testWidgets('transient renewal failures keep inspector consumers stable', (
    tester,
  ) async {
    final eval = _SessionEval();
    final container = _container(eval);
    var builds = 0;
    final inspector = FutureProvider((ref) async {
      await ref.watch(devtoolSessionProvider.future);
      return ++builds;
    });
    container.listen(inspector, (_, _) {});
    expect(await container.read(inspector.future), 1);
    eval.failRenewal = true;
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    expect(await container.read(devtoolSessionProvider.future), 'session-1');
    expect(await container.read(inspector.future), 1);
    eval.failRenewal = false;
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    expect(await container.read(inspector.future), 1);
    expect(eval.sessions, 1);
    expect(
      eval.commands.where((code) => code.contains('renewSession')).length,
      2,
    );
    container.dispose();
    await tester.pump();
  });

  testWidgets('a slow heartbeat does not replace the inspected session', (
    tester,
  ) async {
    final eval = _SessionEval();
    final container = _container(eval);
    final states = <AsyncValue<String>>[];
    container.listen(devtoolSessionProvider, (_, next) => states.add(next));
    expect(await container.read(devtoolSessionProvider.future), 'session-1');
    states.clear();
    final response = eval.pendingRenewal = Completer<Byte<VmInstanceRef>>();
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    expect(container.read(devtoolSessionProvider).requireValue, 'session-1');
    eval.pendingRenewal = null;
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    response.complete(ByteVariable(VmInstance.bool(value: true).ref));
    await tester.pump();
    expect(states, isEmpty);
    expect(eval.sessions, 1);
    expect(
      eval.commands.where((code) => code.contains('renewSession')).length,
      2,
    );
    container.dispose();
    await tester.pump();
  });

  testWidgets('hot restart replaces the session', (tester) async {
    final eval = _SessionEval();
    late Ref restart;
    final container = ProviderContainer.test(
      overrides: [
        hotRestartEventProvider.overrideWith((ref) {
          restart = ref;
        }),
        riverpodEvalProvider.overrideWith((ref) => RiverpodEval(eval)),
      ],
    );
    container.listen(devtoolSessionProvider, (_, _) {});
    await container.read(devtoolSessionProvider.future);
    restart.notifyListeners();
    await tester.pump();
    expect(await container.read(devtoolSessionProvider.future), 'session-2');
    expect(eval.factory.sessionId, 'session-2');
    container.dispose();
    await tester.pump();
  });

  testWidgets('late open responses cannot install an abandoned session', (
    tester,
  ) async {
    final eval = _SessionEval()..pendingOpen = Completer();
    final container = _container(eval);
    container.listen(devtoolSessionProvider, (_, _) {});
    await tester.pump();
    container.dispose();
    eval.pendingOpen!.complete(ByteVariable(VmInstanceRef.string('abandoned')));
    await tester.pump();
    expect(eval.factory.sessionId, isNull);
    expect(
      eval.commands,
      contains('RiverpodDevtool.instance.closeSession("abandoned")'),
    );
  });
}
