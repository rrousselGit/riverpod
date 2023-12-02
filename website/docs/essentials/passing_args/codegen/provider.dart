// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
// A "functional" provider
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // TODO: perform a network request to fetch an activity
  return fetchActivity();
}

// Or alternatively, a "notifier"
@riverpod
class ActivityNotifier2 extends _$ActivityNotifier2 {
  /// Notifier arguments are specified on the build method.
  /// There can be as many as you want, have any name, and even be optional/named.
  @override
  Future<Activity> build(String activityType) async {
    // Arguments are also available with "this.<argumentName>"
    print(this.activityType);

    // TODO: perform a network request to fetch an activity
    return fetchActivity();
  }
}
