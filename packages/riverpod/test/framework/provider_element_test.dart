import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ResultError;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('getState', () {
    test('throws on providers that threw', () {
      final container = createContainer();
      final provider = Provider((ref) => throw UnimplementedError());

      final element = container.readProviderElement(provider);

      expect(
        element.getState(),
        isA<ResultError>()
            .having((e) => e.error, 'error', isUnimplementedError),
      );
    });
  });

  group('readSelf', () {
    test('throws on providers that threw', () {
      final container = createContainer();
      final provider = Provider((ref) => throw UnimplementedError());

      final element = container.readProviderElement(provider);

      expect(
        element.readSelf,
        throwsA(isA<ProviderException>()),
      );
    });
  });

  group('visitChildren', () {
    test('includes ref.watch dependents', () {
      final container = createContainer();
      final provider = Provider((ref) => 0);
      final dependent = Provider((ref) {
        ref.watch(provider);
      });
      final dependent2 = Provider((ref) {
        ref.watch(provider);
      });

      container.read(dependent);
      container.read(dependent2);

      final children = <ProviderElementBase>[];

      container.readProviderElement(provider).visitChildren(children.add);
      expect(
        children,
        unorderedMatches(<Object>[
          isA<ProviderElementBase>()
              .having((e) => e.provider, 'provider', dependent),
          isA<ProviderElementBase>()
              .having((e) => e.provider, 'provider', dependent2),
        ]),
      );
    });

    test('includes ref.listen dependents', () {
      final container = createContainer();
      final provider = Provider((ref) => 0);
      final dependent = Provider((ref) {
        ref.listen(provider, (_, __) {});
      });
      final dependent2 = Provider((ref) {
        ref.listen(provider, (_, __) {});
      });

      container.read(dependent);
      container.read(dependent2);

      final children = <ProviderElementBase>[];

      container.readProviderElement(provider).visitChildren(children.add);
      expect(
        children,
        unorderedMatches(<Object>[
          isA<ProviderElementBase>()
              .having((e) => e.provider, 'provider', dependent),
          isA<ProviderElementBase>()
              .having((e) => e.provider, 'provider', dependent2),
        ]),
      );
    });

    test('include ref.read dependents', () {}, skip: true);
  });

  group('hasListeners', () {
    test('includes provider listeners', () async {
      final provider = Provider((ref) => 0);
      final dep = Provider((ref) {
        ref.listen(provider, (prev, value) {});
      });
      final container = createContainer();

      expect(container.readProviderElement(provider).hasListeners, false);

      container.read(dep);

      expect(container.readProviderElement(provider).hasListeners, true);
    });

    test('includes provider dependents', () async {
      final provider = Provider((ref) => 0);
      final dep = Provider((ref) {
        ref.watch(provider);
      });
      final container = createContainer();

      expect(container.readProviderElement(provider).hasListeners, false);

      container.read(dep);

      expect(container.readProviderElement(provider).hasListeners, true);
    });

    test('includes container listeners', () async {
      final provider = Provider((ref) => 0);
      final container = createContainer();

      expect(container.readProviderElement(provider).hasListeners, false);

      container.listen(provider, (_, __) {});

      expect(container.readProviderElement(provider).hasListeners, true);
    });
  });

  test('does not notify listeners when rebuilding the state', () async {
    final container = createContainer();
    final listener = Listener<int>();

    final dep = StateProvider((ref) => 0);
    final provider = Provider((ref) {
      ref.watch(dep.state).state;
      return ref.state = 0;
    });

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(null, 0));

    container.read(dep.state).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);
  });
}
