import 'package:riverpod/riverpod.dart';

final repositoryProvider = Provider((ref) => Repository());

class Repository {
  Future<void> post(String url) async {}
}

/* SNIPPET START */

final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter(ref);
});

class Counter extends StateNotifier<int> {
  Counter(this.ref) : super(0);

  final Ref ref;

  void increment() {
    // Counter এই "ref" অবজেক্ট ব্যবহার করে অন্য প্রভাইডার পড়তে পারবে
    final repository = ref.read(repositoryProvider);
    repository.post('...');
  }
}
