// ignore_for_file: unnecessary_this, avoid_print

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity(String activityType) =>
    throw UnimplementedError();

/* SNIPPET START */
// “函式型”提供者
final activityProvider = FutureProvider.autoDispose
    // 我們使用 ".family" 修飾符。
    // 泛型型別 "String" 對應於引數的型別。
    // 我們的提供者程式現在在 "ref" 上收到一個額外的引數：activity 的型別。
    .family<Activity, String>((ref, activityType) async {
  // TODO: 使用 "activityType" 執行網路請求以獲取活動
  return fetchActivity(activityType);
});

// “通知者程式”的提供者
final activityProvider2 = AsyncNotifierProvider.autoDispose
    // 再次，我們使用 ".family" 修飾符，並將引數指定為 "String" 型別。
    .family<ActivityNotifier, Activity, String>(
  ActivityNotifier.new,
);

// 當將 ".family" 與通知者程式一起使用時，我們需要更改通知者程式子類：
// AsyncNotifier -> FamilyAsyncNotifier
// AutoDisposeAsyncNotifier -> AutoDisposeFamilyAsyncNotifier
class ActivityNotifier
    extends AutoDisposeFamilyAsyncNotifier<Activity, String> {
  /// Family 引數傳遞給構建方法並可透過 this.arg 訪問
  @override
  Future<Activity> build(String activityType) async {
    // 引數也可透過 "this.arg" 使用
    print(this.arg);

    // TODO: 執行網路請求以獲取活動
    return fetchActivity(activityType);
  }
}
