import 'package:hooks_riverpod/hooks_riverpod.dart';

final a = StateProvider<int>((ref) {
  return 0;
});

final b = StateProvider<int>((ref) {
  ref.watch(a);
  return 0;
});

final c = StateProvider<int>((ref) {
  ref.watch(a);
  return 0;
}, dependencies: [a]);

final d = StateProvider<int>((ref) {
  ref.watch(a);
  return 0;
}, dependencies: []);

final e = StateProvider<int>((ref) {
  ref.watch(a);
  return 0;
}, dependencies: [a, b]);

final f = StateProvider<int>((ref) {
  ref.watch(a.notifier);
  return 0;
}, dependencies: [a]);

final g = StateProvider<int>((ref) {
  ref.watch(b);
  return 0;
}, dependencies: [b]);

final h = StateProvider<int>((ref) {
  ref.watch(c);
  return 0;
}, dependencies: [c]);

final i = StateProvider<int>((ref) {
  ref.watch(c);
  return 0;
});

// Notifier without specified dependencies
final j = StateNotifierProvider<J, int>((ref) {
  return J(ref);
});

class J extends StateNotifier<int> {
  J(this.ref) : super(0);
  final Ref ref;

  void fn() {
    ref.read(a);
  }
}

// Notifier with dependency
final k = StateNotifierProvider<K, int>((ref) {
  return K(ref);
}, dependencies: []);

class K extends StateNotifier<int> {
  K(this.ref) : super(0);
  final Ref ref;

  void fn() {
    ref.read(a);
  }
}

// Provider variants (autoDispose / family)
final l = StateProvider.autoDispose((ref) {
  return 0;
}, dependencies: []);

final m = StateProvider.autoDispose.family((ref, param) {
  return 0;
}, dependencies: [a]);

// Passing ref to a function
final n = StateProvider((ref) {
  fn(ref);
  return 0;
}, dependencies: [a]);

final o = StateProvider((ref) {
  fn(ref);
  return 0;
}, dependencies: []);

void fn(Ref ref) {
  ref.watch(a);
}

final p = StateNotifierProvider<P, int>(P.new);

class P extends StateNotifier<int> {
  P(this.ref) : super(0);
  final Ref ref;

  void fn() {
    ref.read(a);
  }
}

final q = StateNotifierProvider<Q, int>(Q.new, dependencies: []);

class Q extends StateNotifier<int> {
  Q(this.ref) : super(0);
  final Ref ref;

  void fn() {
    ref.read(a);
  }
}

final r =
    StateNotifierProvider<R, int>((ref) => R()..ref = ref, dependencies: []);

class R extends StateNotifier<int> {
  R() : super(0);
  late final Ref ref;

  void fn() {
    ref.read(a);
  }
}

final s = StateProvider((ref) {
  get() => ref;
  get().watch(a);
}, dependencies: []);

// TODO: Ref escape analysis
final t = StateNotifierProvider<T, int>((ref) {
  get() => ref;
  return T(get);
}, dependencies: []);

class T extends StateNotifier<int> {
  T(this.get) : super(0);
  final Ref Function() get;

  void fn() {
    get().read(a);
  }
}

// TODO check dynamic ref invocation