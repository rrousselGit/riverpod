// ignore_for_file: unnecessary_this, avoid_print

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity(String activityType) =>
    throw UnimplementedError();

/* SNIPPET START */
// "함수형" provider
final activityProvider = FutureProvider.autoDispose
    // ".family" 수정자(modifier)를 사용합니다.
    // "String" 제네릭 타입은 인수 타입에 해당합니다.
    // 이제 provider는 "ref" 외에 액티비티 타입이라는 추가 인수를 받습니다.
    .family<Activity, String>((ref, activityType) async {
  // TODO: "activityType"을 사용하여 액티비티를 가져오기 위한 네트워크 요청을 수행합니다.
  return fetchActivity(activityType);
});

// "notifier" provider
final activityProvider2 = AsyncNotifierProvider.autoDispose
    // 여기서도 ".family" 수정자를 사용하고 인수를 "String" 유형으로 지정합니다.
    .family<ActivityNotifier, Activity, String>(
  ActivityNotifier.new,
);

// notifiers에 '.family'를 사용할 때는 notifier 서브클래스를 변경해야 합니다:
// AsyncNotifier -> FamilyAsyncNotifier
// AsyncNotifier -> FamilyAsyncNotifier
class ActivityNotifier extends FamilyAsyncNotifier<Activity, String> {
  /// Family 인자는 빌드 메서드에 전달되며 this.arg로 액세스할 수 있습니다.
  @override
  Future<Activity> build(String activityType) async {
    // 인수는 "this.arg"로도 사용할 수 있습니다.
    print(this.arg);

    // TODO: 액티비티를 가져오기 위한 네트워크 요청을 수행합니다.
    return fetchActivity(activityType);
  }
}
