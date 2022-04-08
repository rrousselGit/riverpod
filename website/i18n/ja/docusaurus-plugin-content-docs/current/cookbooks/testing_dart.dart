import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepository {}

final repositoryProvider = Provider((ref) => FakeRepository());

abstract class Todo {
  String get id;
  String get label;
  bool get completed;
}

final todoListProvider = FutureProvider<List<Todo>>((ref) => []);

void main() {
/* SNIPPET START */

test('override repositoryProvider', () async {
  final container = ProviderContainer(
    overrides: [
      // repositoryProvider の挙動をオーバーライドして
      // Repository の代わりに FakeRepository を戻り値とする
      /* highlight-start */
      repositoryProvider.overrideWithValue(FakeRepository())
      /* highlight-end */
      // `todoListProvider` はオーバーライドされた repositoryProvider を
      // 自動的に利用することになるため、オーバーライド不要
    ],
  );

  // 初期ステートが loading であることを確認
  expect(
    container.read(todoListProvider),
    const AsyncValue<List<Todo>>.loading(),
  );

  /// リクエストの結果が戻るのを待つ
  await container.read(todoListProvider.future);

  // 取得したデータを公開する
  expect(container.read(todoListProvider).value, [
    isA<Todo>()
        .having((s) => s.id, 'id', '42')
        .having((s) => s.label, 'label', 'Hello world')
        .having((s) => s.completed, 'completed', false),
  ]);
});

/* SNIPPET END */
}
