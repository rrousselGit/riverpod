import 'dart:collection';

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:trotter/trotter.dart';

import '../utils.dart';

void main() {
  //  A
  //  |
  //  B
  //  |
  //  C
  test('linear graph', () {
    final watchPermsBuilder = ProviderDependencyPermutation();

    final a = watchPermsBuilder.declareProvider(A());
    final b = watchPermsBuilder.declareProvider(B(), [a]);
    final c = watchPermsBuilder.declareProvider(C(), [b]);

    final watchPerms = watchPermsBuilder.toPermutations();

    for (final watchPerm in watchPerms) {
      final container = createContainer();

      for (final action in watchPerm) {
        action(container);
      }

      expect(compute(container), [a, b, c]);
    }
  });

  //     A
  //   /   \
  //  B     C
  //    \  /
  //      D
  test('diamond graph', () {
    final watchPermsBuilder = ProviderDependencyPermutation();

    final a = watchPermsBuilder.declareProvider(A());
    final b = watchPermsBuilder.declareProvider(B(), [a]);
    final c = watchPermsBuilder.declareProvider(C(), [a]);
    final d = watchPermsBuilder.declareProvider(D(), [b, c]);

    final watchPerms = watchPermsBuilder.toPermutations();
    for (final watchPerm in watchPerms) {
      final container = createContainer();

      for (final action in watchPerm) {
        action(container);
      }

      expect(
        compute(container),
        anyOf([
          [a, b, c, d],
          [a, c, b, d],
        ]),
      );
    }
  });

  //  A#1
  //  |
  //  B#2
  test('linear across two containers', () {
    final a = Provider<A>((ref) => A());

    final b = Provider<B>((ref) {
      ref.watch(a);
      return B();
    });

    final parent = createContainer();
    final container = createContainer(parent: parent, overrides: [b]);
    container.read(b);

    expect(compute(container), [a, b]);
  });

  //  A#1  B#2
  //    \  /
  //     C#2
  test('branching across two containers', () {
    final a = Provider<A>((ref) => A());
    final b = Provider<B>((ref) => B());

    final watchPermsBuilder = ProviderDependencyPermutation();

    final c = watchPermsBuilder.declareProvider(C(), [a, b]);

    final watchPerms = watchPermsBuilder.toPermutations();
    for (final watchPerm in watchPerms) {
      final parent = createContainer();
      final container = createContainer(
        parent: parent,
        overrides: [b, c],
      );

      for (final action in watchPerm) {
        action(container);
      }

      expect(
        compute(container),
        anyOf([
          [b, a, c],
          [a, b, c],
        ]),
      );
    }
  });

  ///       A
  ///     /   \
  ///    B __  |
  ///    |   | |
  ///    E   |-C
  ///   / \    |
  ///  D   F__/|
  ///      \   |
  ///       G_/

  //       A
  //     /   \
  //    B  <  C
  //   / \    / \
  //  D > E <F < G
  test('5', () {
    final watchPermsBuilder = ProviderDependencyPermutation();

    final a = Provider<A>((ref) => A());

    final b = watchPermsBuilder.declareProvider(B(), [a]);

    final e = watchPermsBuilder.declareProvider(E(), [b]);
    final d = watchPermsBuilder.declareProvider(D(), [b, e]);

    final c = watchPermsBuilder.declareProvider(C(), [a, b]);

    final f = watchPermsBuilder.declareProvider(F(), [c, e]);
    final g = watchPermsBuilder.declareProvider(G(), [c, f]);

    final watchPerms = watchPermsBuilder.toPermutations();
    for (final permutation in watchPerms) {
      final container = createContainer();

      for (final action in permutation) {
        action(container);
      }

      expect(
        compute(container),
        anyOf([
          [a, b, c, e, d, f, g],
          [a, b, c, e, f, g, d],
          [a, b, c, e, f, d, g],
          [a, b, e, c, d, f, g],
          [a, b, e, c, f, g, d],
          [a, b, e, c, f, d, g],
          [a, b, e, d, c, f, g],
        ]),
      );
    }
  });

  //     A
  //   /  |
  //  B   |
  //  | \ |
  //  |   C
  //   \ /
  //    D
  test('linked diamond graph', () {
    final a = Provider<A>((ref) => A());

    final watchPerms = ProviderDependencyPermutation();

    final b = watchPerms.declareProvider(B(), [a]);
    final c = watchPerms.declareProvider(C(), [a, b]);
    final d = watchPerms.declareProvider(D(), [b, c]);

    for (final permutation in watchPerms.toPermutations()) {
      final container = createContainer();
      for (final action in permutation) {
        action(container);
      }

      expect(
        compute(container),
        [a, b, c, d],
      );
    }
  });

  //  A
  //  |
  //  B
  //  | \
  //  |  C
  //  | /
  //   D
  test('graph4', () {
    final a = Provider<A>((ref) => A());
    final watchPerms = ProviderDependencyPermutation();

    final b = watchPerms.declareProvider(B(), [a]);
    final c = watchPerms.declareProvider(C(), [b]);
    final d = watchPerms.declareProvider(D(), [b, c]);

    for (final permutation in watchPerms.toPermutations()) {
      final container = createContainer();
      for (final action in permutation) {
        action(container);
      }

      expect(
        compute(container),
        [a, b, c, d],
      );
    }
  });

  //     A
  //   /   \
  //  B     C
  //  |     |
  //  D     |
  //   \   /
  //     E
  test('graph6', () {
    final a = Provider<A>((ref) => A());
    final watchPerms = ProviderDependencyPermutation();

    final b = watchPerms.declareProvider(B(), [a]);
    final c = watchPerms.declareProvider(C(), [a]);

    final d = watchPerms.declareProvider(D(), [b]);

    final e = watchPerms.declareProvider(C(), [d, c]);

    for (final permutation in watchPerms.toPermutations()) {
      final container = createContainer();
      for (final action in permutation) {
        action(container);
      }

      expect(
        compute(container),
        anyOf([
          [a, b, d, c, e],
          [a, b, c, d, e],
          [a, c, b, d, e],
        ]),
      );
    }
  });
}

List<ProviderBase> compute(ProviderContainer container) {
  container.pump();

  final allElements = <ProviderElementBase>{};

  final queue = Queue<ProviderElementBase>.from(
    container.getAllProviderElements(),
  );

  while (queue.isNotEmpty) {
    final element = queue.removeFirst();

    if (allElements.add(element)) {
      element.visitAncestors(queue.add);
      element.visitChildren(queue.add);
    }
  }

  final elementsList = allElements.toList();
  elementsList.sort((a, b) {
    if (a.isScheduledForRedepth || b.isScheduledForRedepth) {
      throw StateError('cannot have isScheduledForRedepth');
    }
    return a.approximatedDepth.compareTo(b.approximatedDepth);
  });

  return elementsList.map((e) => e.origin).toList();
}

class ProviderDependencyPermutation {
  final List<void Function(ProviderContainer)> _actions = [];

  Provider<T> declareProvider<T>(
    T value, [
    List<Provider<Object?>>? dependencies,
  ]) {
    final provider = Provider<T>((ref) => value);

    if (dependencies != null) {
      for (final dep in dependencies) {
        _actions.add((container) {
          // obtain the element while avoiding `readProviderElement` if possible
          // to not "flush" scheduled tasks
          final element = container.getAllProviderElements().firstWhere(
                (element) => element.origin == provider,
                orElse: () => container.readProviderElement<Object?>(provider),
              );

          element.watch(dep);
        });
      }
    }

    return provider;
  }

  Iterable<Iterable<void Function(ProviderContainer)>> toPermutations() {
    final perms = Permutations(_actions.length, _actions);

    if (perms.length < BigInt.from(3000)) return perms();

    return perms
        .sample(3000)
        .cast<Iterable<void Function(ProviderContainer)>>();
  }
}

class A {}

class B {}

class C {}

class D {}

class E {}

class F {}

class G {}
