// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

// Necessary for code-generation to work
part 'codegen.g.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
// {@template functional}
// A "functional" provider
// {@endtemplate}
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // {@template fetchActivity}
  // TODO: perform a network request to fetch an activity
  // {@endtemplate}
  return fetchActivity();
}

// {@template notifier}
// Or alternatively, a "notifier"
// {@endtemplate}
@riverpod
class ActivityNotifier2 extends _$ActivityNotifier2 {
  @override
  Future<Activity> build() async {
    // {@template fetchActivity2}
    // TODO: perform a network request to fetch an activity
    // {@endtemplate}
    return fetchActivity();
  }
}
