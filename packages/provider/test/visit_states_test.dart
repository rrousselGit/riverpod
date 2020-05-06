import 'dart:collection';

import 'package:provider/src/internals.dart';
import 'package:test/test.dart';
import 'package:trotter/trotter.dart';

void main() {
  //  A
  //  |
  //  B
  //  |
  //  C
  test('linear graph', () {
    final a = Provider<int>((state) => 0);

    final b = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });
    final c = Provider<int>((state) {
      state.dependOn(b);
      return 0;
    });

    final perm = Permutations(3, [a, b, c]);
    final expected = [a, b, c];
    for (final permutation in perm()) {
      expect(compute(permutation), expected);
    }
  });
  //     A
  //   /   \
  //  B     C
  //    \  /
  //      D
  test('diamond graph', () {
    final a = Provider<int>((state) => 0);

    final b = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });
    final c = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });

    final d = Provider<int>((state) {
      state..dependOn(b)..dependOn(c);
      return 0;
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      expect(
        compute(permutation),
        anyOf([
          [a, b, c, d],
          [a, c, b, d],
        ]),
      );
    }
  });
  //       A
  //     /   \
  //    B  <  C
  //   / \    / \
  //  D > E <F < G
  test('5', () {
    final a = Provider<int>((state) => 0);

    final b = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });

    final e = Provider<int>((state) {
      state.dependOn(b);
      return 0;
    });
    final d = Provider<int>((state) {
      state..dependOn(b)..dependOn(e);
      return 0;
    });

    final c = Provider<int>((state) {
      state..dependOn(a)..dependOn(b);
      return 0;
    });

    final f = Provider<int>((state) {
      state..dependOn(c)..dependOn(e);
      return 0;
    });
    final g = Provider<int>((state) {
      state..dependOn(c)..dependOn(f);
      return 0;
    });

    final perm = Permutations(7, [a, b, c, d, e, f, g]);
    for (final permutation in perm()) {
      expect(
        compute(permutation),
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
  //   /   \
  //  B  <  C
  //   \   /
  //     D
  test('linked diamond graph', () {
    final a = Provider<int>((state) => 0);

    final b = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });
    final c = Provider<int>((state) {
      state..dependOn(a)..dependOn(b);
      return 0;
    });

    final d = Provider<int>((state) {
      state..dependOn(b)..dependOn(c);
      return 0;
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      expect(
        compute(permutation),
        [a, b, c, d],
      );
    }
  });
  //     A
  //   /
  //  B  <  C
  //   \   /
  //     D
  test('graph4', () {
    final a = Provider<int>((state) => 0);

    final b = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });
    final c = Provider<int>((state) {
      state.dependOn(b);
      return 0;
    });

    final d = Provider<int>((state) {
      state..dependOn(b)..dependOn(c);
      return 0;
    });

    final perm = Permutations(4, [a, b, c, d]);
    for (final permutation in perm()) {
      expect(
        compute(permutation),
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
    final a = Provider<int>((state) => 0);

    final b = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });
    final c = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });

    final d = Provider<int>((state) {
      state.dependOn(b);
      return 0;
    });

    final e = Provider<int>((state) {
      state..dependOn(d)..dependOn(c);
      return 0;
    });

    final perm = Permutations(5, [a, b, c, d, e]);
    for (final permutation in perm()) {
      expect(
        compute(permutation),
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
    final a = Provider<int>((state) => 0);

    final b = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });
    final c = Provider<int>((state) {
      state.dependOn(a);
      return 0;
    });

    final d = Provider<int>((state) {
      state.dependOn(b);
      return 0;
    });

    final e = Provider<int>((state) {
      state..dependOn(d)..dependOn(c);
      return 0;
    });

    final owner = ProviderStateOwner();
    final owner2 = ProviderStateOwner(parent: owner, overrides: [
      c.overrideForSubtree(c),
      d.overrideForSubtree(d),
      e.overrideForSubtree(e),
    ]);

    final perm = Permutations(3, [c, d, e]);
    for (final permutation in perm()) {
      final states = permutation.map(owner2.readProviderState).toSet();
      final result = DoubleLinkedQueue<BaseProvider>();
      visitNodesInDependencyOrder(states, (e) => result.add(e.provider));

      expect(
        result,
        anyOf([
          [c, d, e],
          [d, c, e],
        ]),
      );
    }
  });
}

List<BaseProvider> compute(List<BaseProvider> input) {
  final owner = ProviderStateOwner();

  final states = input.map(owner.readProviderState).toSet();

  final result = DoubleLinkedQueue<BaseProvider>();

  visitNodesInDependencyOrder(states, (e) => result.add(e.provider));

  return [...result];
}
