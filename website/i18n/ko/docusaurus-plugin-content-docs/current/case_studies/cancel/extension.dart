import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/* SNIPPET START */
extension DebounceAndCancelExtension on Ref<Object?> {
  /// [duration] (기본값은 500ms) 동안 기다린 다음 요청에 사용할 수 있는 [http.Client]를 반환합니다.
  ///
  /// 해당 클라이언트는 provider가 폐기되면 자동으로 닫힙니다.
  Future<http.Client> getDebouncedHttpClient([Duration? duration]) async {
    // 먼저 디바운싱을 처리합니다.
    var didDispose = false;
    onDispose(() => didDispose = true);

    // 사용자가 새로 고침을 중단할 때까지 기다리기 위해 요청을 500밀리초 지연합니다.
    await Future<void>.delayed(duration ?? const Duration(milliseconds: 500));

    // 지연 중에 provider가 폐기(disposed)되었다면 사용자가 다시 새로고침했다는 의미입니다.
    // 예외를 던져 요청을 취소합니다.
    // 리버포드에 의해 포착되므로 여기서 예외를 사용하는 것이 안전합니다.
    if (didDispose) {
      throw Exception('Cancelled');
    }

    // 이제 클라이언트를 생성하고 provider가 폐기되면 클라이언트를 닫습니다.
    final client = http.Client();
    onDispose(client.close);

    // 마지막으로 클라이언트를 반환하여 provider가 요청을 할 수 있도록 합니다.
    return client;
  }
}
