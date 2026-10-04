part of '../vm_service.dart';

final devtoolSessionProvider =
    AsyncNotifierProvider.autoDispose<DevtoolSessionNotifier, String>(
      DevtoolSessionNotifier.new,
    );

class DevtoolSessionNotifier extends AsyncNotifier<String> {
  static const heartbeatInterval = Duration(seconds: 10);

  @override
  Future<String> build() async {
    ref.watch(hotRestartEventProvider);
    final alive = ref.disposable();
    final eval = await ref.watch(riverpodEvalProvider.future);
    if (alive.disposed) throw CancelledException();
    final result = await eval.eval(
      'RiverpodDevtool.instance.openSession()',
      isAlive: alive,
    );
    final sessionId = result.require.instance.valueAsString!;
    if (alive.disposed) {
      unawaited(_closeSession(eval, sessionId));
      throw CancelledException();
    }
    eval.factory.sessionId = sessionId;
    var renewing = false;
    final heartbeat = Timer.periodic(heartbeatInterval, (_) async {
      if (renewing) return;
      renewing = true;
      try {
        final result = await eval
            .eval(
              'RiverpodDevtool.instance.renewSession("$sessionId")',
              isAlive: alive,
            )
            .timeout(heartbeatInterval);
        if (result.valueOrNull?.valueAsString != 'true' && !alive.disposed) {
          ref.invalidateSelf();
        }
      } catch (_) {
        if (!alive.disposed) ref.invalidateSelf();
      } finally {
        renewing = false;
      }
    });
    ref.onDispose(() {
      heartbeat.cancel();
      if (eval.factory.sessionId == sessionId) eval.factory.sessionId = null;
      unawaited(_closeSession(eval, sessionId));
    });
    return sessionId;
  }
}

Future<void> _closeSession(Eval eval, String sessionId) async {
  final alive = Disposable();
  try {
    await eval
        .eval(
          'RiverpodDevtool.instance.closeSession("$sessionId")',
          isAlive: alive,
        )
        .timeout(const Duration(seconds: 5));
  } catch (_) {
    // The transport may already be gone. The application's lease timer remains
    // responsible for releasing this session after an abrupt disconnect.
  } finally {
    alive.dispose();
  }
}
