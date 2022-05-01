// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// Criamos um "provider", que armazenará um valor (aqui "Olá, mundo").
// Ao usar um provider, isso nos permite simular/substituir o valor exposto.
final olaMundoProvider = Provider((_) => 'Olá mundo');

void main() {
  // Este objeto é onde será armazenado o estado de nossos providers.
  final container = ProviderContainer();

  // Graças ao "container", podemos ler nosso provider.
  final value = container.read(olaMundoProvider);

  print(value); // Olá mundo
}
