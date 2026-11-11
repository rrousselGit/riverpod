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

        // Code runs in the library of the state, but can use the notifier.
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
