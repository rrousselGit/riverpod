import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import 'utils.dart';

final isAssertionError = isA<AssertionError>();

TypeMatcher isProviderException([Object exceptionMatcher]) {
  return isA<ProviderException>()
      .having((s) => s.exception, 'exception', exceptionMatcher);
}

void main() {
  ProviderContainer container;
  setUp(() {
    container = ProviderContainer();
  });
  tearDown(() {
    container.dispose();
  });

  test("initState can't dirty ancestors", () {
    final ancestor = StateProvider((_) => 0);
    final child = Provider((ref) {
      return ref.watch(ancestor).state++;
    });

    expect(errorsOf(() => container.read(child)), isNotEmpty);
  });

  test('initState can dirty descendants', () {
    StateController<int> counter;
    final rebuildToken = StateProvider((ref) => 0);
    final ancestor = Provider((ref) {
      if (ref.watch(rebuildToken).state > 0) {
        counter.state++;
      }
    });
    final child = StateProvider((ref) {
      ref.watch(ancestor);
      return 0;
    });

    counter = container.read(child);
    container.read(ancestor);

    container.read(rebuildToken).state++;

    container.read(ancestor);
    expect(counter.state, 1);
  });

  test("initState can't dirty siblings", () {
    final ancestor = StateProvider((_) => 0, name: 'ancestor');
    final counter = Counter();
    final sibling = StateNotifierProvider((ref) {
      ref.watch(ancestor).state;
      return counter;
    }, name: 'sibling');
    var didWatchAncestor = false;
    final child = Provider((ref) {
      ref.watch(ancestor);
      didWatchAncestor = true;
      counter.increment();
    }, name: 'child');

    container.read(sibling.state);

    expect(errorsOf(() => container.read(child)), isNotEmpty);
    expect(didWatchAncestor, true);
  });

  test("initState can't mark dirty other provider", () {
    final provider = StateProvider((ref) => 0);
    final provider2 = Provider((ref) {
      ref.read(provider).state = 42;
      return 0;
    });

    expect(container.read(provider).state, 0);

    expect(errorsOf(() => container.read(provider2)), isNotEmpty);
  });

  test("nested initState can't mark dirty other providers", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final nested = Provider((_) => 0);
    final provider2 = Provider((ref) {
      ref.read(nested);
      counter.increment();
      return 0;
    });

    expect(container.read(provider.state), 0);

    expect(errorsOf(() => container.read(provider2)), isNotEmpty);
  });

  test('auto dispose can dirty providers', () async {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    var didDispose = false;
    final provider2 = Provider.autoDispose((ref) {
      ref.onDispose(() {
        didDispose = true;
        counter.increment();
      });
    });

    container.read(provider.state);

    final sub = container.listen(provider2);
    sub.close();

    expect(counter.debugState, 0);

    await Future<void>.value();

    expect(didDispose, true);
    expect(counter.debugState, 1);
  });

  test("Provider can't dirty anything on create", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    List<Object> errors;
    final computed = Provider((ref) {
      errors = errorsOf(counter.increment);
      return 0;
    });
    final listener = Listener();

    expect(container.read(provider.state), 0);

    computed.watchOwner(container, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(errors, isNotEmpty);
  });
}

class Listener extends Mock {
  void call(int value);
}
