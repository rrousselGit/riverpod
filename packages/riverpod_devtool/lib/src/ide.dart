import 'package:devtools_app_shared/utils.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'vm_service.dart';

Future<void> openTraceInIDE(MutationTarget target, Trace trace) async {
  final mutation = Mutation<void>();
  await mutation.run(target, (tsx) async {
    final eval = await tsx.get(riverpodEvalProvider.future);

    final frame = trace.frames.firstOrNull;
    if (frame == null) return;

    await eval.evalInstance(isAlive: Disposable(), '''
        openInIDE(
          uri: '${frame.uri}',
          line: ${frame.line},
          column: ${frame.column}
        )
      ''');
  });
}
