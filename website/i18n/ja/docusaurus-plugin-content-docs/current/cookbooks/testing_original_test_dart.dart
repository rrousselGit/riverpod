import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// Dart のみで実装されたカウンターアプリのテスト

// グローバル定義したプロバイダを2つのテストで使用する
// テスト間でステートが正しく `0` にリセットされるかの確認

final counterProvider = StateProvider((ref) => 0);

// mockito を使ってプロバイダによる Listener への通知を追跡する
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // プロバイダを利用するために必要なオブジェクト
    // このオブジェクトはテスト間で共有しない
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // プロバイダを監視して変化を検出する
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // この時点で Listener はデフォルトの `0` で呼び出されているはず
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // ステートの数字を増やす
    container.read(counterProvider.notifier).state++;

    // 今度は Listener が `1` で呼び出されているか確認
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // ProviderContainer を新たに作成してプロバイダを利用する
    // これによりテスト間でステートが再利用されないことを保証できる
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // このテストでもデフォルト値 `0` が使用されることを確認
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
