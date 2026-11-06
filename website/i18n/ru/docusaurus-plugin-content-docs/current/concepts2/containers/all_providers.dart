// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';

final container = ProviderContainer();

void main() {
  /* SNIPPET START */
  final foo = Provider((ref) => 0);
  final bar = Provider((ref) => 1);

  // Считываем providers, чтобы сделать их активными
  container.read(foo);
  container.read(bar);

  // Выведет (foo, bar)
  print(container.allProviders());
  /* SNIPPET END */
}
