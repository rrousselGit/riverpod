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

final l = StateProvider.autoDispose((ref) {
  return 0;
}, dependencies: []);

final m = StateProvider.autoDispose.family((ref, param) {
  return 0;
}, dependencies: [a]);

// TODO check random Service
// TODO test passing ref to a function/method