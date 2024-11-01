// ignore_for_file: avoid_print, unreachable_from_main

/* SNIPPET START */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
@riverpod
String helloWorld(Ref ref) {
  return 'Hello world';
}

void main() {
  // This object is where the state of our providers will be stored.
  final container = ProviderContainer();

  // Thanks to "container", we can read our provider.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
