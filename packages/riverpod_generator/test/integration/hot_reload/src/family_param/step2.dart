// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step2.g.dart';

@riverpod
String fn(FnRef ref, {required int id2}) => 'id2: $id2';

void renderer(ProviderContainer container) {
  print(container.listen(fnProvider(id2: 0), (_, __) {}).read());
}
