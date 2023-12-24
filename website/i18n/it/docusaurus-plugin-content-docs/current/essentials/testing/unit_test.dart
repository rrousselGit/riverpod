// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = Provider((_) => 42);

/* SNIPPET START */
void main() {
  test('Some description', () {
    // Crea un ProviderContainer per questo test.
    // NON condividere dei ProviderContainer tra i test.
    final container = createContainer();

    // TODO: usare il container per testare la tua applicazione.
    expect(
      container.read(provider),
      equals('some value'),
    );
  });
}
