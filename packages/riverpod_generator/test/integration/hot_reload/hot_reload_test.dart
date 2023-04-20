import 'package:test/test.dart';

import 'hot_reload_utils.dart';

void main() {
  group('Supports family hot-reload', () {
    test(
      'by recursively deleting _stateReaders of affected providers',
      () async {},
    );

    test(
      'gracefully handles not disposing providers twice when debugReassemble'
      ' is called multiple times on the same contaiener',
      () async {},
    );

    test(
      'handles changing default values',
      () async {},
    );

    test(
      'disposes of providers in the correct order',
      () async {},
    );

    test(timeout: const Timeout.factor(2), 'when adding/removing parameters',
        () async {
      final runner = await HotReloadRunner.start(r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'renderer.g.dart';

// Reused through hot reload
final container = ProviderContainer();

@riverpod
String fn(FnRef ref, {required int id}) {
  ref.onDispose(() {
    print('disposing step1 $id');
  });
  return 'id: $id';
}

void renderer() {
  print(container.listen(fnProvider(id: 0), (_, __) {}).read());
}
''');

      expect(await runner.currentRender.next, 'id: 0');

      await runner.updateRenders(r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'renderer.g.dart';

// Reused through hot reload
final container = ProviderContainer();

@riverpod
String fn(FnRef ref, {required int id2}) => 'id2: $id2';

void renderer() {
  print(
    'Provider count before reassemble: '
    '${container.getAllProviderElements().length}',
  );
  container.debugReassemble();
  print(
    'Provider count after reassemble: '
    '${container.getAllProviderElements().length}',
  );
  print(container.listen(fnProvider(id2: 0), (_, __) {}).read());
}
''');

      expect(
        await runner.currentRender.next,
        '''
Provider count before reassemble: 1
disposing step1 0
Provider count after reassemble: 0
id2: 0''',
      );
    });
  });

  test(
    'Updates providers if they ref.watch a provider which changed Element',
    () {},
  );

  test(
    'Updates providers if they ref.listen a provider which changed Element',
    () {},
  );

  test('Preserves the state of unedited providers', () {});

  test('Supports switching in/out family', () {});

  test('Supports enabling/disabling autoDispose', () {});

  test('Supports changing the runtimeType of a provider', () {});

  test('Supports adding/removing overrides', () {});
}
