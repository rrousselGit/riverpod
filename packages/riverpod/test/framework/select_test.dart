import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('correctly updates the list of dependents/dependencies', () {
    final container = createContainer();

    final a = FutureProvider((ref) => 0);
    final b = FutureProvider(
      (ref) => ref.watch(a.select((data) => Object())),
    );

    container.read(b);

    final aElement = container.readProviderElement(a);
    final bElement = container.readProviderElement(b);

    expect(aElement.dependencies, isEmpty);
    expect(bElement.dependencies.keys, [aElement]);

    expect(aElement.dependents, [bElement]);
    expect(bElement.dependents, isEmpty);
  });

  test('when selector throws, rebuild providers', () {}, skip: true);

  test('on provider that threw, exceptions bypass the selector', () {
    final container = createContainer();
    final dep = Provider<int>((ref) {
      throw UnimplementedError();
    });
    final provider = Provider<int>((ref) {
      return ref.watch(dep.select((value) => throw StateError('message')));
    });

    expect(
      () => container.read(provider),
      throwsUnimplementedError,
    );
  });

  test('can chain select', () {
    final container = createContainer();

    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final provider = Provider((ref) {
      buildCount++;
      return ref.watch(
        dep.select((value) => value % 10).select((value) => value < 5),
      );
    });

    expect(buildCount, 0);
    expect(container.read(provider), true);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 3;

    expect(container.read(provider), true);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 7;

    expect(container.read(provider), false);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 8;

    expect(container.read(provider), false);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 18;

    expect(container.read(provider), false);
    expect(buildCount, 2);
  });

  test(
      'when rebuilding a provider after an uncaught selected exception, correctly updates dependents',
      () {
    final container = createContainer();
    final throws = StateProvider((ref) => true);
    final provider = Provider((ref) {
      if (ref.watch(throws)) {
        throw UnimplementedError();
      }
      return 0;
    });

    final dep = Provider((ref) {
      return ref.watch(provider.select((value) => value));
    });

    expect(
      () => container.read(dep),
      throwsUnimplementedError,
    );

    container.read(throws.notifier).state = false;

    expect(container.read(dep), 0);
  });

  test('throw when trying to use ref.read inside selectors during initial call',
      () {
    final dep = Provider((ref) => 0, name: 'dep');
    final provider = Provider(
      name: 'provider',
      (ref) {
        ref.watch(dep.select((value) => ref.read(dep)));
      },
    );
    final container = createContainer();

    expect(
      () => container.read(provider),
      throwsA(isA<AssertionError>()),
    );
  });

  test(
      'throw when trying to use ref.watch inside selectors during initial call',
      () {
    final dep = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.watch(dep.select((value) => ref.watch(dep)));
    });
    final container = createContainer();

    expect(
      () => container.read(provider),
      throwsA(isA<AssertionError>()),
    );
  });

  test(
      'throw when trying to use ref.listen inside selectors during initial call',
      () {
    final dep = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.watch(
        dep.select((value) {
          ref.listen(dep, (prev, value) {});
          return 0;
        }),
      );
    });
    final container = createContainer();

    expect(
      () => container.read(provider),
      throwsA(isA<AssertionError>()),
    );
  });

  test(
      'when selecting a provider, element.visitChildren visits the selected provider',
      () {
    final container = createContainer();
    final selected = StateNotifierProvider<StateController<int>, int>((ref) {
      return StateController(0);
    });
    final provider = Provider((ref) {
      ref.watch(selected.select((value) => null));
    });

    final element = container.readProviderElement(provider);
    final selectedElement = container.readProviderElement(selected);

    final ancestors = <ProviderElementBase<Object?>>[];
    element.visitAncestors(ancestors.add);

    expect(ancestors, [selectedElement]);
  });

  test('can watch selectors', () {
    final container = createContainer();
    final provider = StateNotifierProvider<StateController<int>, int>(
      name: 'provider',
      (ref) => StateController(0),
    );
    final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
    final isEvenListener = Listener<bool>();
    var buildCount = 0;

    final another = Provider<bool>(
      name: 'another',
      (ref) {
        buildCount++;
        return ref.watch(provider.select(isEvenSelector.call));
      },
    );

    container.listen(another, isEvenListener.call, fireImmediately: true);

    expect(buildCount, 1);
    verifyOnly(isEvenListener, isEvenListener(null, true));
    verifyOnly(isEvenSelector, isEvenSelector(0));

    container.read(provider.notifier).state = 2;

    expect(container.read(another), true);
    expect(buildCount, 1);
    verifyOnly(isEvenSelector, isEvenSelector(2));
    verifyNoMoreInteractions(isEvenListener);

    container.read(provider.notifier).state = 3;

    expect(container.read(another), false);
    expect(buildCount, 2);
    verify(isEvenSelector(3)).called(2);
    verifyOnly(isEvenListener, isEvenListener(true, false));
  });
}
