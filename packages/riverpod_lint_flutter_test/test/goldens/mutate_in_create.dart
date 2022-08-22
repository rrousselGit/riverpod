import 'package:hooks_riverpod/hooks_riverpod.dart';

final a = StateProvider((ref) => 'String');

final b = Provider<bool>((ref) {
  ref.watch(a.notifier).state = '';
  return false;
});

final c = StateNotifierProvider<C, int>((ref) {
  return C(ref);
});

class C extends StateNotifier<int> {
  C(this.ref) : super(0) {
    ref.read(a.notifier).state = '';
    Future.delayed(Duration(milliseconds: 10), () {
      ref.read(a.notifier).state = '';
    });
    ref.read(a.notifier).state = '';
    fn();
    fn2();
    fn3();
  }
  final Ref ref;

  void fn() {
    ref.read(a.notifier).state = '';
  }

  // Not okay
  Future<void> fn2() async {
    ref.read(a.notifier).state = '';
    await Future.delayed(Duration(seconds: 1));
  }

  // Okay
  Future<void> fn3() async {
    await Future.delayed(Duration(seconds: 1));
    ref.read(a.notifier).state = '';
  }
}
