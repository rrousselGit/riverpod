import 'package:riverpod/riverpod.dart';

import 'common.dart';

const int _kNumIterations = 100000;
const int _kNumWarmUp = 1000;

void main() {
  assert(
    false,
    "Don't run benchmarks in checked mode! Use 'flutter run --release'.",
  );

  final printer = BenchmarkResultPrinter();
  const scale = 1000.0 / _kNumIterations;
  final watch = Stopwatch();
  final provider = Provider((ref) => 0);

  // Warm up lap
  for (var i = 0; i < _kNumWarmUp; i += 1) {
    final container = ProviderContainer();
    final providers = List.generate(500, (index) => Provider((ref) => index));
    providers.forEach(container.read);
  }

  watch.reset();
  for (var i = 0; i < _kNumIterations; i += 1) {
    final container = ProviderContainer();
    pushProviders(10, container);
    watch.start();
    container.read(provider);
    watch.stop();
  }
  final create10Time = watch.elapsedMicroseconds;

  printer.addResult(
    description: 'create10',
    value: create10Time * scale,
    unit: 'ns per iteration',
    name: 'create10_iteration',
  );

  watch.reset();
  for (var i = 0; i < _kNumIterations; i += 1) {
    final container = ProviderContainer();
    pushProviders(100, container);
    watch.start();
    container.read(provider);
    watch.stop();
  }
  final create100Time = watch.elapsedMicroseconds;

  printer.addResult(
    description: 'create100',
    value: create100Time * scale,
    unit: 'ns per iteration',
    name: 'create100_iteration',
  );

  watch.reset();
  for (var i = 0; i < _kNumIterations; i += 1) {
    final container = ProviderContainer();
    pushProviders(500, container);
    watch.start();
    container.read(provider);
    watch.stop();
  }
  final create500Time = watch.elapsedMicroseconds;

  printer.addResult(
    description: 'create500',
    value: create500Time * scale,
    unit: 'ns per iteration',
    name: 'create500_iteration',
  );

  watch.reset();
  for (var i = 0; i < _kNumIterations; i += 1) {
    final container = ProviderContainer();
    pushProviders(2000, container);
    watch.start();
    container.read(provider);
    watch.stop();
  }
  final create2000Time = watch.elapsedMicroseconds;

  printer.addResult(
    description: 'create2000',
    value: create2000Time * scale,
    unit: 'ns per iteration',
    name: 'create2000_iteration',
  );

  printer.printToStdout();
}

void pushProviders(int count, ProviderContainer container) {
  final providers = List.generate(1, (index) => Provider((ref) => index));
  providers.forEach(container.read);
}
