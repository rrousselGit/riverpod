import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  StreamController<int> controller;
  final provider = StreamProvider((ref) => controller.stream);
  ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    controller = StreamController<int>(sync: true);
  });
  tearDown(() {
    container.dispose();
    controller.close();
  });

  test('Loading to data', () {
    expect(container.read(provider), const AsyncValue<int>.loading());

    controller.add(42);

    expect(container.read(provider), const AsyncValue<int>.data(42));
  });
  test('Loading to error', () {
    expect(container.read(provider), const AsyncValue<int>.loading());

    final stack = StackTrace.current;
    controller.addError(42, stack);

    expect(container.read(provider), AsyncValue<int>.error(42, stack));
  });
  test('does not filter identical values', () {
    final sub = container.listen(provider);

    expect(sub.read(), const AsyncValue<int>.loading());

    controller.add(42);

    expect(sub.flush(), true);
    expect(sub.read(), const AsyncValue<int>.data(42));

    controller.add(42);

    expect(sub.flush(), true);
    expect(sub.read(), const AsyncValue<int>.data(42));
  });
}
