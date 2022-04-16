// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// On crée un "provider", qui va stocker une valeur (ici "Hello world").
// En utilisant un provider, cela nous permet de simuler/supprimer la valeur exposée.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // Cet objet est l'endroit où l'état de nos providers sera stocké.
  final container = ProviderContainer();

  // Grâce au "container", nous pouvons lire notre provider.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
