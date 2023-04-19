// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step1.g.dart';

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
