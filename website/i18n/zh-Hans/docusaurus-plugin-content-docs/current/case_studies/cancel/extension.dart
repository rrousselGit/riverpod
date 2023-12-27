import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/* SNIPPET START */
extension DebounceAndCancelExtension on Ref {
  /// 等待 [duration]（默认为 500ms），
  /// 然后返回一个 [http.Client]，用于发出请求。
  ///
  /// 当提供者程序被处置时，该客户端将自动关闭。
  Future<http.Client> getDebouncedHttpClient([Duration? duration]) async {
    // 首先，我们要处理去抖问题。
    var didDispose = false;
    onDispose(() => didDispose = true);

    // 我们将请求延迟 500 毫秒，以等待用户停止刷新。
    await Future<void>.delayed(duration ?? const Duration(milliseconds: 500));

    // 如果在延迟期间处理了提供者程序，则意味着用户再次刷新了请求。
    // 我们会抛出一个异常来取消请求。
    // 在这里使用异常是安全的，因为它会被 Riverpod 捕捉到。
    if (didDispose) {
      throw Exception('Cancelled');
    }

    // 现在我们创建客户端，并在处理提供者程序时关闭客户端。
    final client = http.Client();
    onDispose(client.close);

    // 最后，我们返回客户端，让我们的提供者程序提出请求。
    return client;
  }
}
