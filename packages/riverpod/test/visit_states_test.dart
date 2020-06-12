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
      ref.dependOn(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.dependOn(b);
      return C();
    });

    final perm = Permutations(3, [a, b, c]);
    for (final permutation in perm()) {
      final owner = ProviderStateOwner();
      for (final provider in permutation) {
        provider.readOwner(owner);
      }
      expect(compute(owner), [a, b, c]);
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
      ref.dependOn(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.dependOn(a);
      return C();
    });

    final d = Provider<D>((ref) {
      ref..dependOn(b)..dependOn(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final owner = ProviderStateOwner();
      for (final provider in permutation) {
        provider.readOwner(owner);
      }
      expect(
        compute(owner),
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
      ref.dependOn(a);
      return B();
    });

    final e = Provider<E>((ref) {
      ref.dependOn(b);
      return E();
    });
    final d = Provider<D>((ref) {
      ref..dependOn(b)..dependOn(e);
      return D();
    });

    final c = Provider<C>((ref) {
      ref..dependOn(a)..dependOn(b);
      return C();
    });

    final f = Provider<F>((ref) {
      ref..dependOn(c)..dependOn(e);
      return F();
    });
    final g = Provider<G>((ref) {
      ref..dependOn(c)..dependOn(f);
      return G();
    });

    final perm = Permutations(7, [a, b, c, d, e, f, g]);
    for (final permutation in perm()) {
      final owner = ProviderStateOwner();
      for (final provider in permutation) {
        provider.readOwner(owner);
      }
      expect(
        compute(owner),
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
      ref.dependOn(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref..dependOn(a)..dependOn(b);
      return C();
    });

    final d = Provider<D>((ref) {
      ref..dependOn(b)..dependOn(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final owner = ProviderStateOwner();
      for (final provider in permutation) {
        provider.readOwner(owner);
      }
      expect(
        compute(owner),
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
      ref.dependOn(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.dependOn(b);
      return C();
    });

    final d = Provider<D>((ref) {
      ref..dependOn(b)..dependOn(c);
      return D();
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      final owner = ProviderStateOwner();
      for (final provider in permutation) {
        provider.readOwner(owner);
      }
      expect(
        compute(owner),
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
      ref.dependOn(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.dependOn(a);
      return C();
    });

    final d = Provider<D>((ref) {
      ref.dependOn(b);
      return D();
    });

    final e = Provider<E>((ref) {
      ref..dependOn(d)..dependOn(c);
      return E();
    });

    final perm = Permutations(5, [a, b, c, d, e]);
    for (final permutation in perm()) {
      final owner = ProviderStateOwner();
      for (final provider in permutation) {
        provider.readOwner(owner);
      }
      expect(
        compute(owner),
        anyOf([
          [a, b, d, c, e],
          [a, b, c, d, e],
          [a, c, b, d, e],
        ]),
      );
    }
  });
  //     A(0)
  //   /   \
  //  B(0)  C(1)
  //  |     |
  //  D(1)  |
  //   \   /
  //     E(1)
  test('graph7', () {
    final a = Provider<A>((ref) => A());

    final b = Provider<B>((ref) {
      ref.dependOn(a);
      return B();
    });
    final c = Provider<C>((ref) {
      ref.dependOn(a);
      return C();
    });

    final d = Provider<D>((ref) {
      ref.dependOn(b);
      return D();
    });

    final e = Provider<E>((ref) {
      ref..dependOn(d)..dependOn(c);
      return E();
    });

    final perm = Permutations(3, [c, d, e]);
    for (final permutation in perm()) {
      final owner = ProviderStateOwner();
      final owner2 = ProviderStateOwner(parent: owner, overrides: [
        c.overrideAs(c),
        d.overrideAs(d),
        e.overrideAs(e),
      ]);

      for (final provider in permutation) {
        provider.readOwner(owner2);
      }

      expect(
        compute(owner2),
        anyOf([
          [c, d, e],
          [d, c, e],
        ]),
      );
    }
  });
}

List<ProviderBase> compute(ProviderStateOwner owner) {
  return owner.debugProviderStates.map((e) => e.provider).toList();
}

class A {}

class B {}

class C {}

class D {}

class E {}

class F {}

class G {}
