// ignore_for_file: unnecessary_this, avoid_print

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity(String activityType) =>
    throw UnimplementedError();

/* SNIPPET START */
// “函数型”提供者
final activityProvider = FutureProvider.autoDispose
    // 我们使用 ".family" 修饰符。
    // 泛型类型 "String" 对应于参数的类型。
    // 我们的提供者程序现在在 "ref" 上收到一个额外的参数：activity 的类型。
    .family<Activity, String>((ref, activityType) async {
  // TODO: 使用 "activityType" 执行网络请求以获取活动
  return fetchActivity(activityType);
});

// “通知者程序”的提供者
final activityProvider2 = AsyncNotifierProvider.autoDispose
    // 再次，我们使用 ".family" 修饰符，并将参数指定为 "String" 类型。
    .family<ActivityNotifier, Activity, String>(
  ActivityNotifier.new,
);

// 当将 ".family" 与通知者程序一起使用时，我们需要更改通知者程序子类：
// AsyncNotifier -> FamilyAsyncNotifier
// AutoDisposeAsyncNotifier -> AutoDisposeFamilyAsyncNotifier
class ActivityNotifier
    extends AutoDisposeFamilyAsyncNotifier<Activity, String> {
  /// Family 参数传递给构建方法并可通过 this.arg 访问
  @override
  Future<Activity> build(String activityType) async {
    // 参数也可通过 "this.arg" 使用
    print(this.arg);

    // TODO: 执行网络请求以获取活动
    return fetchActivity(activityType);
  }
}
