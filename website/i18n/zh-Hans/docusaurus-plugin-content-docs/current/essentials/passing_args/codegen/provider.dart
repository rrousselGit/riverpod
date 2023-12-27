// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
// “函数型”提供者程序
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // TODO: 执行网络请求以获取活动
  return fetchActivity();
}

// 或者替代方案，“通知者程序”
@riverpod
class ActivityNotifier2 extends _$ActivityNotifier2 {
  /// 通知者程序参数在构建方法上指定。
  /// 可以有任意数量的通知者程序参数，可以是任意的变量名称，甚至可以是可选/命名的参数。
  @override
  Future<Activity> build(String activityType) async {
    // 参数也可通过 "this.<argumentName>" 使用
    print(this.activityType);

    // TODO: 执行网络请求以获取活动
    return fetchActivity();
  }
}
