import 'package:devtools_app_shared/utils.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'vm_service.dart';

Future<void> openTraceInIDE(MutationTarget target, String stackTrace) async {
  final mutation = Mutation<void>();
  await mutation.run(target, (tsx) async {
    final eval = await tsx.get(riverpodEvalProvider.future);

    final trace = Trace.parse(stackTrace);

    final frame = trace.frames.firstOrNull;
    if (frame == null) return;

    final res = await eval.evalInstance(isAlive: Disposable(), '''
        openInIDE(
          uri: '${frame.uri}',
          line: ${frame.line},
          column: ${frame.column}
        )
      ''');

    res.require; // Rethrow any errors
  });
}
