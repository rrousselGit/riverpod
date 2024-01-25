// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // This object is where the state of our providers will be stored.
  final container = ProviderContainer();

  // Thanks to "container", we can read our provider.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
