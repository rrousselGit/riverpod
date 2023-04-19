// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step1.g.dart';

@riverpod
String fn(FnRef ref, {required int id}) => 'id: $id';

void renderer(ProviderContainer container) {
  print(container.listen(fnProvider(id: 0), (_, __) {}).read());
}
