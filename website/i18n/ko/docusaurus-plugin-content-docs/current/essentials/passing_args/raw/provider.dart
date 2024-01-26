import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

/* SNIPPET START */

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

// "함수형" provider
final activityProvider = FutureProvider.autoDispose((ref) async {
  // TODO: 액티비티를 가져오기 위한 네트워크 요청을 수행합니다.
  return fetchActivity();
});

// 또는, "notifier"
final activityProvider2 = AsyncNotifierProvider<ActivityNotifier, Activity>(
  ActivityNotifier.new,
);

class ActivityNotifier extends AsyncNotifier<Activity> {
  @override
  Future<Activity> build() async {
    // TODO: 액티비티를 가져오기 위한 네트워크 요청을 수행합니다.
    return fetchActivity();
  }
}
