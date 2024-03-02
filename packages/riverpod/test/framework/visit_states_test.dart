import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:trotter/trotter.dart';

import '../providers/notifier/factory.dart';
import '../utils.dart';

abstract class SubscriptionFactory {
  void dependOn(Ref ref, ProviderListenable<void> provider);

  @override
  @mustBeOverridden
  String toString();
}

class _WatchFactory extends SubscriptionFactory {
  @override
  void dependOn(Ref ref, ProviderListenable<void> provider) {
    ref.unsafeWatch(provider);
  }

  @override
  String toString() => 'watch';
}

class _ListenFactory extends SubscriptionFactory {
  @override
  void dependOn(Ref ref, ProviderListenable<void> provider) {
    ref.unsafeListen<void>(provider, (_, __) {
      ref.invalidateSelf();
    });
  }

  @override
  String toString() => 'listen';
}

class _Graph {
  _Graph(this.sub, this.edges);

  final SubscriptionFactory sub;
  final Map<String, List<String>> edges;

  var _trackBuild = false;
  final logs = <String>[];

  late final Map<String, FutureProvider<Object?>> _providers = {
    for (final entry in edges.entries)
      entry.key: FutureProvider<Object?>(name: entry.key, (ref) {
        if (_trackBuild) logs.add(entry.key);
        for (final dependency in entry.value) {
          sub.dependOn(ref, _providers[dependency]!);
        }
        return Object();
      }),
  };

  void invalidate(ProviderContainer container, String key) {
    final provider = _providers[key]!;
    container.invalidate(provider);
  }

  ProviderContainer createAll() {
    final container = createContainer();
    logs.clear();
    _trackBuild = false;
    for (final provider in _providers.values) {
      container.listen(provider, (_, __) {});
    }
    _trackBuild = true;

    return container;
  }
}

void main() {
  for (final sub in [_WatchFactory(), _ListenFactory()]) {
    group('$sub', () {
      //  A
      //  |
      //  B
      //  |
      //  C
      test(
          'When two indirectly nodes are invalidated, '
          'rebuild the intermediate one before the leaf one', () async {
        final graph = _Graph(sub, {
          'A': [],
          'B': ['A'],
          'C': ['B'],
        });

        final container = graph.createAll();
        graph.invalidate(container, 'A');
        graph.invalidate(container, 'C');

        await container.pump();

        expect(graph.logs, ['A', 'B', 'C']);
      });

      //  A
      //  |
      //  B
      //  |
      //  C
      test('linear graph', () {
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
          return B();
        });
        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, b);
          return C();
        });

        final perm = Permutations(3, [a, b, c]);
        for (final permutation in perm()) {
          final container = createContainer();
          permutation.forEach(container.read);
          expect(compute(container), [a, b, c]);
        }
      });
      //  A
      //  |
      //  B
      //  |
      //  C
      test('linear graph', () {
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
          return B();
        });
        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, b);
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
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
          return B();
        });
        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, a);
          return C();
        });

        final d = FutureProvider<D>((ref) {
          sub.dependOn(ref, b);
          sub.dependOn(ref, c);
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
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
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
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          return B();
        });

        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, a);
          sub.dependOn(ref, b);
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
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
          return B();
        });

        final e = FutureProvider<E>((ref) {
          sub.dependOn(ref, b);
          return E();
        });
        final d = FutureProvider<D>((ref) {
          sub.dependOn(ref, b);
          sub.dependOn(ref, e);
          return D();
        });

        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, a);
          sub.dependOn(ref, b);
          return C();
        });

        final f = FutureProvider<F>((ref) {
          sub.dependOn(ref, c);
          sub.dependOn(ref, e);
          return F();
        });
        final g = FutureProvider<G>((ref) {
          sub.dependOn(ref, c);
          sub.dependOn(ref, f);
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
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
          return B();
        });
        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, a);
          sub.dependOn(ref, b);
          return C();
        });

        final d = FutureProvider<D>((ref) {
          sub.dependOn(ref, b);
          sub.dependOn(ref, c);
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
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
          return B();
        });
        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, b);
          return C();
        });

        final d = FutureProvider<D>((ref) {
          sub.dependOn(ref, b);
          sub.dependOn(ref, c);
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
        final a = FutureProvider<A>((ref) => A());

        final b = FutureProvider<B>((ref) {
          sub.dependOn(ref, a);
          return B();
        });
        final c = FutureProvider<C>((ref) {
          sub.dependOn(ref, a);
          return C();
        });

        final d = FutureProvider<D>((ref) {
          sub.dependOn(ref, b);
          return D();
        });

        final e = FutureProvider<E>((ref) {
          sub.dependOn(ref, d);
          sub.dependOn(ref, c);
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
    });
  }
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
