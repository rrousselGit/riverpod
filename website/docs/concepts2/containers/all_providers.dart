// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';

final container = ProviderContainer();

void main() {
  /* SNIPPET START */
  final foo = Provider((ref) => 0);
  final bar = Provider((ref) => 1);

  // Read the providers to make them active
  container.read(foo);
  container.read(bar);

  // Prints (foo, bar)
  print(container.allProviders());
  /* SNIPPET END */
}
