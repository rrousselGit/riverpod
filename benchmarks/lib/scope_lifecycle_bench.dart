import 'package:riverpod/riverpod.dart';

import 'common.dart';

const int _kNumIterations = 2000;
const int _kNumWarmUp = 100;

/// The end-to-end cost of a scope: create it, read some providers through it,
/// then dispose it. This is what a route or a list item actually does.
///
/// Where `scope_bench.dart` times creation and disposal on their own, this one
/// also covers the reads in between, so that work deferred out of creation
/// still shows up somewhere.
void main() {
  assert(
    false,
    "Don't run benchmarks in checked mode! Use 'dart run' or 'flutter run --release'.",
  );

  final printer = BenchmarkResultPrinter();
  final watch = Stopwatch();

  /// Builds a scope [depth] containers below [root], reads [toRead] through it
  /// and disposes it.
  double measure(
    ProviderContainer root,
    List<Provider<int>> toRead, {
    required int depth,
  }) {
    final trigger = Provider<int>((ref) => 0, name: 'trigger');
    final overrides = [trigger.overrideWithValue(1)];

    ProviderContainer build() {
      var container = root;
      for (var d = 0; d < depth; d++) {
        container = ProviderContainer(parent: container, overrides: overrides);
      }
      return container;
    }

    for (var i = 0; i < _kNumWarmUp; i++) {
      final leaf = build();
      for (final provider in toRead) {
        leaf.read(provider);
      }
      leaf.dispose();
    }

    watch.reset();
    for (var i = 0; i < _kNumIterations; i++) {
      watch.start();
      final leaf = build();
      for (final provider in toRead) {
        leaf.read(provider);
      }
      leaf.dispose();
      watch.stop();
    }

    return watch.elapsedMicroseconds * 1000.0 / _kNumIterations;
  }

  for (final rootSize in [100, 1000]) {
    final providers = List.generate(
      rootSize,
      (i) => Provider<int>((ref) => i, name: 'p$i'),
    );
    final root = ProviderContainer();
    providers.forEach(root.read);

    // A scope normally reads a handful of the providers an application has
    // mounted. The last case is the worst one: it reads all of them.
    for (final depth in [1, 5]) {
      for (final reads in [5, 50, rootSize]) {
        printer.addResult(
          description: 'root $rootSize, depth $depth, $reads reads',
          value: measure(root, providers.take(reads).toList(), depth: depth),
          unit: 'ns per iteration',
          name: 'root${rootSize}_depth${depth}_read$reads',
        );
      }
    }

    root.dispose();
  }

  printer.printToStdout();
}
