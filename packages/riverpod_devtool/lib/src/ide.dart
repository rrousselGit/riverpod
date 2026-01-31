import 'package:devtools_app_shared/utils.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'vm_service.dart';

Future<void> openTraceInIDE(MutationTarget target, Trace trace) async {
  const _riverpodPackages = {
    'riverpod',
    'hooks_riverpod',
    'flutter_riverpod',
    'riverpod_generator',
  };

  final mutation = Mutation<void>();
  await mutation.run(target, (tsx) async {
    final eval = await tsx.get(riverpodEvalProvider.future);

    final firstNonRiverpodFrame = trace.frames
        .where(
          (frame) =>
              !_riverpodPackages.contains(frame.package) &&
              !frame.uri.path.endsWith('.g.dart'),
        )
        .firstOrNull;
    if (firstNonRiverpodFrame == null) return;

    await eval.evalInstance(isAlive: Disposable(), '''
        openInIDE(
          uri: '${firstNonRiverpodFrame.uri}',
          line: ${firstNonRiverpodFrame.line},
          column: ${firstNonRiverpodFrame.column}
        )
      ''');
  });
}
