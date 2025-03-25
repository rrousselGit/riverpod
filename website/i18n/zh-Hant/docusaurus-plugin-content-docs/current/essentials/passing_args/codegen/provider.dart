// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
// “函式型”提供者程式
@riverpod
Future<Activity> activity(Ref ref) async {
  // TODO: 執行網路請求以獲取活動
  return fetchActivity();
}

// 或者替代方案，“通知者程式”
@riverpod
class ActivityNotifier2 extends _$ActivityNotifier2 {
  /// 通知者程式引數在構建方法上指定。
  /// 可以有任意數量的通知者程式引數，可以是任意的變數名稱，甚至可以是可選/命名的引數。
  @override
  Future<Activity> build(String activityType) async {
    // 引數也可透過 "this.<argumentName>" 使用
    print(this.activityType);

    // TODO: 執行網路請求以獲取活動
    return fetchActivity();
  }
}
