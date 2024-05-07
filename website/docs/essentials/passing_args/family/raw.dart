// ignore_for_file: unnecessary_this, avoid_print

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity(String activityType) => throw UnimplementedError();

/* SNIPPET START */
final activityProvider = FutureProvider.autoDispose
    // {@template raw_family}
    // We use the ".family" modifier.
    // The "String" generic type corresponds to the argument type.
    // Our provider now receives an extra argument on top of "ref": the activity type.
    // {@endtemplate}
    .family<Activity, String>((ref, activityType) async {
  // {@template raw_family_todo}
  // TODO: perform a network request to fetch an activity using "activityType"
  // {@endtemplate}
  return fetchActivity(activityType);
});

// {@template raw_activityProvider2}
// Again, for notifier we use the ".family" modifier, and specify the argument as type "String".
// {@endtemplate}
final activityProvider2 = AsyncNotifierProvider.autoDispose.family<ActivityNotifier, Activity, String>(
  ActivityNotifier.new,
);

// {@template raw_ActivityNotifier}
// When using ".family" with notifiers, we need to change the notifier subclass:
// AsyncNotifier -> FamilyAsyncNotifier
// AutoDisposeAsyncNotifier -> AutoDisposeFamilyAsyncNotifier
// {@endtemplate}
class ActivityNotifier extends AutoDisposeFamilyAsyncNotifier<Activity, String> {
  // {@template raw_build}
  /// Family arguments are passed to the build method and accessible with this.arg
  // {@endtemplate}
  @override
  Future<Activity> build(String activityType) async {
    // {@template raw_args}
    // Arguments are also available with "this.arg"
    // {@endtemplate}
    print(this.arg);

    // {@template todo}
    // TODO: perform a network request to fetch an activity
    // {@endtemplate}
    return fetchActivity(activityType);
  }
}
