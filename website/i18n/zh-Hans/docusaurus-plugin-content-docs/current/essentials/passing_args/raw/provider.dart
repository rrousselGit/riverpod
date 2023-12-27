import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

/* SNIPPET START */

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

// “函数型”提供者程序
final activityProvider = FutureProvider.autoDispose((ref) async {
  // TODO: 执行网络请求以获取活动
  return fetchActivity();
});

// 或者替代方案，“通知者程序”
final activityProvider2 = AsyncNotifierProvider<ActivityNotifier, Activity>(
  ActivityNotifier.new,
);

class ActivityNotifier extends AsyncNotifier<Activity> {
  @override
  Future<Activity> build() async {
    // TODO: 执行网络请求以获取活动
    return fetchActivity();
  }
}
