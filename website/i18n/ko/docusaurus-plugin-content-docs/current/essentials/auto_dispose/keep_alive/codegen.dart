// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<String> example(ExampleRef ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // 요청이 성공적으로 완료된 후에만 프로바이더를 살아있게 유지합니다.
  // 요청이 실패한 경우(그리고 throw된 경우), 공급자에 청취를 중단하면 상태가 소멸됩니다.
  ref.keepAlive();

  // `link`를 사용하여 자동 폐기 동작을 복원할 수 있습니다:
  // link.close();

  return response.body;
}
