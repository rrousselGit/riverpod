// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step2.g.dart';

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
