import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate' as dart_isolate;

import 'package:fake_async/fake_async.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/src/connection.dart';
import 'package:riverpod_devtool_core/src/elements.dart';
import 'package:riverpod_devtool_core/src/frames.dart';
import 'package:riverpod_devtool_core/src/inspector.dart';
import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// An [AppConnection] whose isolate and connection state tests control.
class FakeConnection implements AppConnection {
  FakeConnection(this.service, {IsolateRef? isolate})
    : _isolate = isolate ?? IsolateRef(id: 'isolates/1', name: 'main');

  @override
  final VmService service;

  final _listeners = <void Function()>[];

  @override
  IsolateRef? get isolate => _isolate;
  IsolateRef? _isolate;
  set isolate(IsolateRef? value) {
    _isolate = value;
    _notify();
  }

  @override
  bool get connected => _connected;
  bool _connected = true;
  set connected(bool value) {
    _connected = value;
    _notify();
  }

  bool get hasListeners => _listeners.isNotEmpty;

  void _notify() {
    for (final listener in _listeners.toList()) {
      listener();
    }
  }

  @override
  void addListener(void Function() listener) => _listeners.add(listener);

  @override
  void removeListener(void Function() listener) => _listeners.remove(listener);
}

/// Controls the fake clock of [testFakeAsync].
class FakeTime {
  FakeTime._(this._async);
  final FakeAsync _async;

  /// Lets pending work complete, after [duration] elapsed if specified.
  Future<void> pump([Duration? duration]) async {
    if (duration != null) _async.elapse(duration);
    _async.flushMicrotasks();
  }
}

/// A [test] whose timers only fire when [FakeTime.pump] says so.
void testFakeAsync(String name, Future<void> Function(FakeTime time) body) {
  test(name, () {
    fakeAsync((async) {
      var done = false;
      unawaited(body(FakeTime._(async)).whenComplete(() => done = true));
      async.flushMicrotasks();
      expect(
        done,
        isTrue,
        reason: 'The test waits on something that never completes',
      );
    });
  });
}

/// The application of `test/fixtures/app.dart`, running in its own process.
class TestApp {
  TestApp._(this._process, this.connection);

  final Process _process;
  final VmServiceConnection connection;

  /// A container whose providers inspect this application.
  ProviderContainer container() {
    return ProviderContainer.test(
      overrides: [appConnectionProvider.overrideWith((ref) => connection)],
    );
  }

  Future<void> close() async {
    await connection.dispose();
    _process.kill();
    await _process.exitCode;
  }
}

/// Starts `test/fixtures/app.dart` and connects to its VM service.
///
/// The application is stopped once the current test or group is done.
/// [script] runs a copy of the fixture instead, such as one that a test edits
/// to hot-reload it.
Future<TestApp> startApp({String script = 'test/fixtures/app.dart'}) async {
  final packages = await dart_isolate.Isolate.packageConfig;
  final process = await Process.start(Platform.resolvedExecutable, [
    '--enable-vm-service=0',
    '--no-dds',
    '--disable-service-auth-codes',
    '--no-serve-devtools',
    '--enable-asserts',
    // A copy of the fixture is outside of this package.
    '--packages=${packages!.toFilePath()}',
    script,
  ]);
  // Before anything can fail, or the application would outlive the tests.
  addTearDown(() async {
    process.kill();
    await process.exitCode;
  });
  final lines = StreamIterator(
    process.stdout.transform(utf8.decoder).transform(const LineSplitter()),
  );
  final listening = RegExp(r'listening on http://127\.0\.0\.1:(\d+)/');
  String? port;
  // The application prints "ready" once its providers exist.
  while (await lines.moveNext() && lines.current != 'ready') {
    port ??= listening.firstMatch(lines.current)?.group(1);
  }

  final service = await vmServiceConnectUri('ws://127.0.0.1:$port/ws');
  addTearDown(service.dispose);
  return TestApp._(process, await VmServiceConnection.start(service));
}

extension InspectApp on ProviderContainer {
  /// Waits for [provider] to emit a value matching [test].
  Future<ValueT> waitFor<ValueT>(
    ProviderListenable<AsyncValue<ValueT>> provider,
    bool Function(ValueT value) test,
  ) {
    final result = Completer<ValueT>();
    final subscription = listen(provider, fireImmediately: true, (_, next) {
      // Rebuilding providers still expose their previous value.
      if (result.isCompleted || next.isLoading) return;
      if (next.error case final error?) {
        result.completeError(error, next.stackTrace);
      } else if (next.value case final value? when test(value)) {
        result.complete(value);
      }
    });
    return result.future.whenComplete(subscription.close);
  }

  /// The latest state of the provider named [name] in the application.
  Future<ElementMeta> element(String name) async {
    // Inspected objects only stay readable while frames are listened to.
    listen(framesProvider, (_, _) {});
    final frames = await waitFor(framesProvider, (frames) => frames.isNotEmpty);
    return frames.last.elements.values.firstWhere(
      (element) => element.provider.origin.toStringValue == name,
    );
  }

  /// Increments the counter of the application.
  Future<void> increment() async {
    final counter = await element('counterProvider');
    final eval = await read(evalProvider.future);
    final isAlive = Disposable();
    final notifier = await counter.notifier!.state.readRef(eval, isAlive);
    final result = await eval.dartCore.eval(
      r'($notifier as dynamic).increment()',
      isAlive: isAlive,
      scope: {r'$notifier': notifier.require.instance.id!},
    );
    result.require;
  }

  /// Reads [object] the way an inspector does.
  Future<Byte<ResolvedVariable>> resolve(CachedObject object) {
    return waitFor(resolvedVariableForObjectProvider(object), (_) => true);
  }
}
