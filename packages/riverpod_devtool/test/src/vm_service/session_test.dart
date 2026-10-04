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

ProviderContainer _container(_SessionEval eval) => ProviderContainer(
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
    final container = ProviderContainer(
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

  testWidgets('transport failures replace the lease', (tester) async {
    final eval = _SessionEval();
    final container = _container(eval);
    container.listen(devtoolSessionProvider, (_, _) {});
    await container.read(devtoolSessionProvider.future);
    eval.failRenewal = true;
    await tester.pump(DevtoolSessionNotifier.heartbeatInterval);
    expect(await container.read(devtoolSessionProvider.future), 'session-2');
    container.dispose();
    await tester.pump();
  });

  testWidgets('hot restart replaces the session', (tester) async {
    final eval = _SessionEval();
    late Ref restart;
    final container = ProviderContainer(
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
