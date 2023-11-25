// ignore_for_file: unnecessary_this, avoid_print

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity(String activityType) =>
    throw UnimplementedError();

/* SNIPPET START */
// A "functional" provider
final activityProvider = FutureProvider.autoDispose
    // We use the ".family" modifier.
    // The "String" generic type corresponds to the argument type.
    // Our provider now receives an extra argument on top of "ref": the activity type.
    .family<Activity, String>((ref, activityType) async {
  // TODO: perform a network request to fetch an activity using "activityType"
  return fetchActivity(activityType);
});

// A "notifier" provider
final activityProvider2 = AsyncNotifierProvider.autoDispose
    // Again, we use the ".family" modifier, and specify the argument as type "String".
    .family<ActivityNotifier, Activity, String>(
  ActivityNotifier.new,
);

// When using ".family" with notifiers, we need to change the notifier subclass:
// AsyncNotifier -> FamilyAsyncNotifier
// AutoDisposeAsyncNotifier -> AutoDisposeFamilyAsyncNotifier
class ActivityNotifier
    extends AutoDisposeFamilyAsyncNotifier<Activity, String> {
  /// Family arguments are passed to the build method and accessible with this.arg
  @override
  Future<Activity> build(String activityType) async {
    // Arguments are also available with "this.arg"
    print(this.arg);

    // TODO: perform a network request to fetch an activity
    return fetchActivity(activityType);
  }
}
