import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final repositoryProvider = Provider((ref) => Repository());

class Repository {
  Future<void> post(String url) async {}
}

/* SNIPPET START */

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() {
    // Counter can use the "ref" to read other providers
    final repository = ref.read(repositoryProvider);
    repository.post('...');
  }
}
