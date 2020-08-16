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
  var container = ProviderContainer();
  const scale = 1000.0 / _kNumIterations;
  final watch = Stopwatch();
  final provider = Provider((ref) => 0);

  // Warm up lap
  for (var i = 0; i < _kNumWarmUp; i += 1) {
    container = ProviderContainer();
    final providers = List.generate(500, (index) => Provider((ref) => index));
    providers.forEach(container.read);
  }

  container = ProviderContainer();
  watch.start();
  for (var i = 0; i < _kNumIterations; i += 1) {
    container.read(provider);
  }
  watch.stop();
  final read1 = watch.elapsedMicroseconds;

  printer.addResult(
    description: 'read1',
    value: read1 * scale,
    unit: 'ns per iteration',
    name: 'read1_iteration',
  );

  container = ProviderContainer();
  pushProviders(10, container);
  watch.reset();
  watch.start();
  for (var i = 0; i < _kNumIterations; i += 1) {
    container.read(provider);
  }
  watch.stop();
  final read10 = watch.elapsedMicroseconds;
  watch.reset();

  printer.addResult(
    description: 'read10',
    value: read10 * scale,
    unit: 'ns per iteration',
    name: 'read10_iteration',
  );

  container = ProviderContainer();
  pushProviders(50, container);
  watch.reset();
  watch.start();
  for (var i = 0; i < _kNumIterations; i += 1) {
    container.read(provider);
  }
  watch.stop();
  final read50 = watch.elapsedMicroseconds;
  watch.reset();

  printer.addResult(
    description: 'read50',
    value: read50 * scale,
    unit: 'ns per iteration',
    name: 'read50_iteration',
  );

  container = ProviderContainer();
  pushProviders(500, container);
  watch.reset();
  watch.start();
  for (var i = 0; i < _kNumIterations; i += 1) {
    container.read(provider);
  }
  watch.stop();
  final read500 = watch.elapsedMicroseconds;
  watch.reset();

  printer.addResult(
    description: 'read500',
    value: read500 * scale,
    unit: 'ns per iteration',
    name: 'read500_iteration',
  );

  printer.printToStdout();
}

void pushProviders(int count, ProviderContainer container) {
  final providers = List.generate(1, (index) => Provider((ref) => index));
  providers.forEach(container.read);
}
