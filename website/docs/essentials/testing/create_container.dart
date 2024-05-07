/* SNIPPET START */
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

// {@template createContainer}
/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
// {@endtemplate}
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // {@template container}
  // Create a ProviderContainer, and optionally allow specifying parameters.
  // {@endtemplate}
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // {@template addTearDown}
  // When the test ends, dispose the container.
  // {@endtemplate}
  addTearDown(container.dispose);

  return container;
}
