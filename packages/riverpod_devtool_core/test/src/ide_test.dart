import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/src/ide.dart';
import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';

class _Eval implements Eval {
  final commands = <String>[];
  Byte<VmInstance> result = ByteVariable(VmInstance.null_());

  @override
  Future<Byte<VmInstance>> evalInstance(
    String code, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    commands.add(code.replaceAll(RegExp(r'\s+'), ' ').trim());
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('openTraceInIDE', () {
    late _Eval eval;
    late ProviderContainer container;
    setUp(() {
      eval = _Eval();
      container = ProviderContainer.test(
        overrides: [
          riverpodEvalProvider.overrideWith((ref) => RiverpodEval(eval)),
        ],
      );
    });

    test('asks the IDE to navigate to the first frame of the trace', () async {
      await openTraceInIDE(
        container,
        '#0      main (file:///app/lib/main.dart:12:5)\n'
        '#1      other (file:///app/lib/other.dart:1:1)\n',
      );

      expect(eval.commands, [
        "openInIDE( uri: 'file:///app/lib/main.dart', line: 12, column: 5 )",
      ]);
    });

    test('does nothing for empty traces', () async {
      await openTraceInIDE(container, '');

      expect(eval.commands, isEmpty);
    });

    test('fails when the application cannot notify the IDE', () async {
      eval.result = ByteError(UnknownEvalErrorType('no IDE'));

      await expectLater(
        openTraceInIDE(container, '#0      main (file:///main.dart:1:1)\n'),
        throwsStateError,
      );
    });
  });
}
