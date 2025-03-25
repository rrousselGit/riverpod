/* SNIPPET START */ import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'activity.dart';

// 程式碼生成正常工作的必要條件
part 'provider.g.dart';

/// 這將建立一個名為 `activityProvider` 的提供者程式
/// 它可以快取函式執行的結果
@riverpod
Future<Activity> activity(Ref ref) async {
  // 使用 package:http, 我們可以從 Bored API 獲取一個隨機的活動。
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  // 使用 dart:convert, 然後我們將 JSON 有效負載解碼為 Map 資料結構。
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // 最後，我們將 Map 轉換為 Activity 例項。
  return Activity.fromJson(json);
}
