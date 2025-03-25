import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/* SNIPPET START */
extension DebounceAndCancelExtension on Ref {
  /// 等待 [duration]（預設為 500ms），
  /// 然後返回一個 [http.Client]，用於發出請求。
  ///
  /// 當提供者程式被處置時，該客戶端將自動關閉。
  Future<http.Client> getDebouncedHttpClient([Duration? duration]) async {
    // 首先，我們要處理去抖問題。
    var didDispose = false;
    onDispose(() => didDispose = true);

    // 我們將請求延遲 500 毫秒，以等待使用者停止重新整理。
    await Future<void>.delayed(duration ?? const Duration(milliseconds: 500));

    // 如果在延遲期間處理了提供者程式，則意味著使用者再次重新整理了請求。
    // 我們會丟擲一個異常來取消請求。
    // 在這裡使用異常是安全的，因為它會被 Riverpod 捕捉到。
    if (didDispose) {
      throw Exception('Cancelled');
    }

    // 現在我們建立客戶端，並在處理提供者程式時關閉客戶端。
    final client = http.Client();
    onDispose(client.close);

    // 最後，我們返回客戶端，讓我們的提供者程式提出請求。
    return client;
  }
}
