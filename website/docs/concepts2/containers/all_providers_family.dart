// ignore_for_file: avoid_print

import 'package:riverpod/riverpod.dart';

final container = ProviderContainer();

void main() {
  /* SNIPPET START */
  final foo = Provider.family<int, int>((ref, id) => id);
  final bar = Provider((ref) => 0);

  // Read the providers to make them active
  container.read(foo(0));
  container.read(foo(1));
  container.read(bar);

  // Prints (foo(0), foo(1))
  print(container.allProviders(family: foo));
  /* SNIPPET END */
}
