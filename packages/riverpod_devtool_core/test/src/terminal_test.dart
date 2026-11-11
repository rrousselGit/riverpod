import 'package:riverpod_devtool_core/src/frames.dart';
import 'package:riverpod_devtool_core/src/terminal.dart';
import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('evalInTerminal', () {
    late TestApp app;
    setUpAll(() async => app = await startApp());

    test(
      'evaluates code against the state, notifier and previous result',
      () async {
        final container = app.container();
        final counter = await container.element('counterProvider');
        final eval = await container.read(evalProvider.future);
        final isAlive = Disposable();

        Future<Byte<RootCachedObject>> run(
          String code, {
          RootCachedObject? previous,
        }) {
          return evalInTerminal(
            code,
            eval,
            state: counter.state.state,
            notifier: counter.notifier?.state,
            previous: previous,
            isAlive: isAlive,
          );
        }

        Future<Object?> valueOf(Byte<RootCachedObject> byte) async {
          final value = await byte.require.instance.read(
            eval,
            isAlive: isAlive,
          );
          return value.require.instance.valueAsString;
        }

        final state = await run(r'$state + 10');
        expect(await valueOf(state), '10');

        final previous = await run(
          r'($previous as int) * 2',
          previous: state.require.instance,
        );
        expect(await valueOf(previous), '20');

        await run(r'($notifier as dynamic).increment()');
        final updated = await container.waitFor(
          framesProvider,
          (frames) =>
              frames.last.elements[counter.provider.elementId]?.state !=
              counter.state,
        );
        final newState =
            updated.last.elements[counter.provider.elementId]!.state;
        expect(
          (await newState.state.read(
            eval,
            isAlive: isAlive,
          )).require.instance.valueAsString,
          '1',
        );

        await state.require.instance.delete(eval, isAlive: isAlive);
        expect(
          await state.require.instance.read(eval, isAlive: isAlive),
          isA<ByteError<VmInstance>>(),
        );
      },
    );

    test('runs in the library of the notifier', () async {
      final container = app.container();
      final counter = await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);
      final isAlive = Disposable();

      // The state is an int, whose library does not know about Counter.
      final result = await evalInTerminal(
        r'$notifier is Counter && counterProvider.name == "counterProvider"',
        eval,
        state: counter.state.state,
        notifier: counter.notifier!.state,
        previous: null,
        isAlive: isAlive,
      );

      final value = await result.require.instance.read(eval, isAlive: isAlive);
      expect(value.require.instance.valueAsString, 'true');
    });

    test('variables without a value are null', () async {
      final container = app.container();
      final provider = await container.element('doubleProvider');
      final eval = await container.read(evalProvider.future);
      final isAlive = Disposable();
      expect(provider.notifier, isNull);

      Future<String?> run(String code, {RootCachedObject? previous}) async {
        final result = await evalInTerminal(
          code,
          eval,
          state: provider.state.state,
          notifier: null,
          previous: previous,
          isAlive: isAlive,
        );
        final value = await result.require.instance.read(
          eval,
          isAlive: isAlive,
        );
        return value.require.instance.valueAsString;
      }

      expect(await run(r'[$notifier, $previous].toString()'), '[null, null]');
      expect(await run(r'$previous == null'), 'true');
      // Statements that return nothing are still accepted.
      expect(await run(r'print($notifier)'), 'null');

      final previous = await evalInTerminal(
        '21',
        eval,
        state: provider.state.state,
        notifier: null,
        previous: null,
        isAlive: isAlive,
      );
      expect(
        await run(
          r'[$notifier, $previous].toString()',
          previous: previous.require.instance,
        ),
        '[null, 21]',
      );
    });

    test('reports code that does not compile as the user typed it', () async {
      final container = app.container();
      final counter = await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);

      for (final notifier in [counter.notifier!.state, null]) {
        final result = await evalInTerminal(
          r'$state + unknown',
          eval,
          state: counter.state.state,
          notifier: notifier,
          previous: null,
          isAlive: Disposable(),
        );

        expect(
          result,
          isA<ByteError<RootCachedObject>>().having(
            // Neither the code around what was typed nor the session show.
            (e) => e.error,
            'error',
            isA<CompilationErrorType>().having(
              (e) => e.toString(),
              'toString',
              "Error: Undefined name 'unknown'.\n"
                  r'$state + unknown'
                  '\n'
                  '         ^^^^^^^',
            ),
          ),
        );
      }
    });

    test('reports code that fails as an error', () async {
      final container = app.container();
      final counter = await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);

      final result = await evalInTerminal(
        'throw StateError("nope")',
        eval,
        state: counter.state.state,
        notifier: null,
        previous: null,
        isAlive: Disposable(),
      );

      expect(
        result,
        isA<ByteError<RootCachedObject>>().having(
          (e) => e.error.toString(),
          'error',
          contains('nope'),
        ),
      );
    });

    test('fails once when nothing can be read anymore', () async {
      final container = app.container();
      final counter = await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);

      // Failures that nothing handles would fail this test.
      await expectLater(
        evalInTerminal(
          '0',
          eval,
          state: counter.state.state,
          notifier: counter.notifier?.state,
          previous: counter.state.state,
          isAlive: Disposable()..dispose(),
        ),
        throwsA(isA<CancelledException>()),
      );
      await pumpEventQueue();
    });

    test('reports objects that cannot be read anymore', () async {
      final container = app.container();
      final counter = await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);
      final gone = RootCachedObject(CacheId('${eval.sessionId}:gone'));

      for (final (state, notifier, previous) in [
        (gone, null, null),
        (counter.state.state, gone, null),
        (counter.state.state, null, gone),
      ]) {
        final result = await evalInTerminal(
          '0',
          eval,
          state: state,
          notifier: notifier,
          previous: previous,
          isAlive: Disposable(),
        );

        expect(
          result,
          isA<ByteError<RootCachedObject>>().having(
            (e) => e.error.toString(),
            'error',
            contains('no longer retained'),
          ),
        );
      }
    });
  });
}
