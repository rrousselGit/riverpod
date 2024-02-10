// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
// "함수형" provider
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // TODO: 네트워크 요청을 수행하여 액티비티를 가져옵니다
  return fetchActivity();
}

// 또는, "notifier"
@riverpod
class ActivityNotifier2 extends _$ActivityNotifier2 {
  /// Notifier 인자(arguments)는 빌드 메서드에 지정됩니다.
  /// 원하는 개수만큼 지정할 수 있고, 이름도 지정할 수 있으며, 선택적/명명할 수도 있습니다.
  @override
  Future<Activity> build(String activityType) async {
    // 인수는 "this.<argumentName>"으로도 사용할 수 있습니다.
    print(this.activityType);

    // TODO: 네트워크 요청을 수행하여 액티비티를 가져옵니다
    return fetchActivity();
  }
}
