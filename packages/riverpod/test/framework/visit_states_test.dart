// import 'package:riverpod/src/internals.dart';
// import 'package:test/test.dart';
// import 'package:trotter/trotter.dart';

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
    final a = Provider<A>((ref) => A());

    final b = Provider<B>((ref) {
      ref.watch(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.watch(b);
      return C();
    });

    final perm = Permutations(3, [a, b, c]);
    for (final permutation in perm()) {
      final container = createContainer();
      permutation.forEach(container.read);
      expect(compute(container), [a, b, c]);
    }
  });
  //     A
  //   /   \
  //  B     C
  //    \  /
  //      D
  test('diamond graph', () {
    final a = Provider<A>((ref) => A());

    final b = Provider<B>((ref) {
      ref.watch(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.watch(a);
      return C();
    });

    final d = Provider<D>((ref) {
      ref.watch(b);
      ref.watch(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final container = createContainer();
      permutation.forEach(container.read);
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

    expect(compute(container), [b]);
    expect(compute(parent), [a]);
  });

  //  A#1  B#2
  //    \  /
  //     C#2
  test('branching across two containers', () {
    final a = Provider<A>((ref) => A());

    final b = Provider<B>((ref) {
      return B();
    });

    final c = Provider<C>((ref) {
      ref.watch(a);
      ref.watch(b);
      return C();
    });

    final parent = createContainer();

    final perm = Permutations(2, [b, c]);
    for (final permutation in perm()) {
      final container = createContainer(
        parent: parent,
        overrides: permutation,
      );
      permutation.forEach(container.read);

      expect(compute(container), [b, c]);
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
    final a = Provider<A>((ref) => A());

    final b = Provider<B>((ref) {
      ref.watch(a);
      return B();
    });

    final e = Provider<E>((ref) {
      ref.watch(b);
      return E();
    });
    final d = Provider<D>((ref) {
      ref.watch(b);
      ref.watch(e);
      return D();
    });

    final c = Provider<C>((ref) {
      ref.watch(a);
      ref.watch(b);
      return C();
    });

    final f = Provider<F>((ref) {
      ref.watch(c);
      ref.watch(e);
      return F();
    });
    final g = Provider<G>((ref) {
      ref.watch(c);
      ref.watch(f);
      return G();
    });

    final perm = Permutations(7, [a, b, c, d, e, f, g]);
    for (final permutation in perm()) {
      final container = createContainer();
      permutation.forEach(container.read);
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

    final b = Provider<B>((ref) {
      ref.watch(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.watch(a);
      ref.watch(b);
      return C();
    });

    final d = Provider<D>((ref) {
      ref.watch(b);
      ref.watch(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final container = createContainer();
      permutation.forEach(container.read);
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

    final b = Provider<B>((ref) {
      ref.watch(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.watch(b);
      return C();
    });

    final d = Provider<D>((ref) {
      ref.watch(b);
      ref.watch(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final container = createContainer();
      permutation.forEach(container.read);
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

    final b = Provider<B>((ref) {
      ref.watch(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.watch(a);
      return C();
    });

    final d = Provider<D>((ref) {
      ref.watch(b);
      return D();
    });

    final e = Provider<E>((ref) {
      ref.watch(d);
      ref.watch(c);
      return E();
    });

    final perm = Permutations(5, [a, b, c, d, e]);
    for (final permutation in perm()) {
      final container = createContainer();
      permutation.forEach(container.read);
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

List<ProviderBase<Object?>> compute(ProviderContainer container) {
  return container
      .getAllProviderElementsInOrder()
      .map((e) => e.provider)
      .toList();
}

class A {}

class B {}

class C {}

class D {}

class E {}

class F {}

class G {}
