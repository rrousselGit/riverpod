import 'package:riverpod/riverpod.dart';
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
    // Counter可以使用“ref”读取其他provider
    final repository = ref.read(repositoryProvider);
    repository.post('...');
  }
}
