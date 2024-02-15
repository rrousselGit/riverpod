// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

// Necessary for code-generation to work
part 'codegen.g.dart';

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
  @override
  Future<Activity> build() async {
    // TODO: perform a network request to fetch an activity
    return fetchActivity();
  }
}
