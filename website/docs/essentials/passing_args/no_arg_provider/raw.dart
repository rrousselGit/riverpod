import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */

// {@template functional}
// A "functional" provider
// {@endtemplate}
final activityProvider = FutureProvider.autoDispose((ref) async {
  // {@template fetchActivity}
  // TODO: perform a network request to fetch an activity
  // {@endtemplate}
  return fetchActivity();
});

// {@template notifier}
// Or alternatively, a "notifier"
// {@endtemplate}
final activityProvider2 = AsyncNotifierProvider<ActivityNotifier, Activity>(
  ActivityNotifier.new,
);

class ActivityNotifier extends AsyncNotifier<Activity> {
  @override
  Future<Activity> build() async {
    // {@template fetchActivity2}
    // TODO: perform a network request to fetch an activity
    // {@endtemplate}
    return fetchActivity();
  }
}
