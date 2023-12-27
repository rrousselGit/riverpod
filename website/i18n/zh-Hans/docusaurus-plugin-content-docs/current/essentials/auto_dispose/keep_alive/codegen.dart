// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<String> example(ExampleRef ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // 只有在请求成功完成后，我们才会让提供者程序存活。
  // 如果请求失败（并抛出异常），那么当提供者程序停止被监听时，
  // 状态就会被处置。
  ref.keepAlive();

  // 我们可以使用 `link` 恢复自动处置行为：
  // link.close();

  return response.body;
}
