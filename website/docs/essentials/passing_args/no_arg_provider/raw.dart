import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
// A "functional" provider
final activityProvider = FutureProvider.autoDispose((ref) async {
  // TODO: perform a network request to fetch an activity
  return fetchActivity();
});

// Or alternatively, a "notifier"
final activityProvider2 = AsyncNotifierProvider<ActivityNotifier, Activity>(
  ActivityNotifier.new,
);

class ActivityNotifier extends AsyncNotifier<Activity> {
  @override
  Future<Activity> build() async {
    // TODO: perform a network request to fetch an activity
    return fetchActivity();
  }
}
