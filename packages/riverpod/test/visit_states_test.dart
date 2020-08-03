import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';
import 'package:trotter/trotter.dart';

void main() {
  //  A
  //  |
  //  B
  //  |
  //  C
  test('linear graph', () {
    final a = Provider<A>((ref) => A());

    final b = Provider<B>((ref) {
      ref.read(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.read(b);
      return C();
    });

    final perm = Permutations(3, [a, b, c]);
    for (final permutation in perm()) {
      final container = ProviderContainer();
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
      ref.read(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.read(a);
      return C();
    });

    final d = Provider<D>((ref) {
      ref..read(b)..read(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final container = ProviderContainer();
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
      ref.read(a);
      return B();
    });

    final e = Provider<E>((ref) {
      ref.read(b);
      return E();
    });
    final d = Provider<D>((ref) {
      ref..read(b)..read(e);
      return D();
    });

    final c = Provider<C>((ref) {
      ref..read(a)..read(b);
      return C();
    });

    final f = Provider<F>((ref) {
      ref..read(c)..read(e);
      return F();
    });
    final g = Provider<G>((ref) {
      ref..read(c)..read(f);
      return G();
    });

    final perm = Permutations(7, [a, b, c, d, e, f, g]);
    for (final permutation in perm()) {
      final container = ProviderContainer();
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
      ref.read(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref..read(a)..read(b);
      return C();
    });

    final d = Provider<D>((ref) {
      ref..read(b)..read(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final container = ProviderContainer();
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
      ref.read(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.read(b);
      return C();
    });

    final d = Provider<D>((ref) {
      ref..read(b)..read(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final container = ProviderContainer();
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
      ref.read(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.read(a);
      return C();
    });

    final d = Provider<D>((ref) {
      ref.read(b);
      return D();
    });

    final e = Provider<E>((ref) {
      ref..read(d)..read(c);
      return E();
    });

    final perm = Permutations(5, [a, b, c, d, e]);
    for (final permutation in perm()) {
      final container = ProviderContainer();
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

List<ProviderBase> compute(ProviderContainer container) {
  return container.debugProviderStates.map((e) => e.provider).toList();
}

class A {}

class B {}

class C {}

class D {}

class E {}

class F {}

class G {}
