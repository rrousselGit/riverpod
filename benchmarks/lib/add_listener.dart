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
    container.listen(provider, (_, __) {}).close();
  }

  container = ProviderContainer();
  for (var i = 0; i < _kNumIterations; i += 1) {
    watch.start();
    final sub = container.listen(provider, (_, __) {});
    watch.stop();
    sub.close();
  }
  final read1 = watch.elapsedMicroseconds;

  printer.addResult(
    description: '1',
    value: read1 * scale,
    unit: 'ns per iteration',
    name: 'add_listener1_iteration',
  );

  container = ProviderContainer();
  pushListener(10, container, provider);
  watch.reset();
  watch.start();
  for (var i = 0; i < _kNumIterations; i += 1) {
    watch.start();
    final sub = container.listen(provider, (_, __) {});
    watch.stop();
    sub.close();
  }
  watch.stop();
  final read10 = watch.elapsedMicroseconds;
  watch.reset();

  printer.addResult(
    description: 'add_listener10',
    value: read10 * scale,
    unit: 'ns per iteration',
    name: 'add_listener10_iteration',
  );

  container = ProviderContainer();
  pushListener(50, container, provider);
  watch.reset();
  watch.start();
  for (var i = 0; i < _kNumIterations; i += 1) {
    watch.start();
    final sub = container.listen(provider, (_, __) {});
    watch.stop();
    sub.close();
  }
  watch.stop();
  final read50 = watch.elapsedMicroseconds;
  watch.reset();

  printer.addResult(
    description: 'add_listener50',
    value: read50 * scale,
    unit: 'ns per iteration',
    name: 'add_listener50_iteration',
  );

  container = ProviderContainer();
  pushListener(500, container, provider);
  watch.reset();
  watch.start();
  for (var i = 0; i < _kNumIterations; i += 1) {
    watch.start();
    final sub = container.listen(provider, (_, __) {});
    watch.stop();
    sub.close();
  }
  watch.stop();
  final read500 = watch.elapsedMicroseconds;
  watch.reset();

  printer.addResult(
    description: 'add_listener500',
    value: read500 * scale,
    unit: 'ns per iteration',
    name: 'add_listener500_iteration',
  );

  printer.printToStdout();
}

void pushListener(
  int count,
  ProviderContainer container,
  Provider<Object?> provider,
) {
  for (var i = 0; i < count; i++) {
    container.listen<void>(provider, (_, __) {});
  }
}
