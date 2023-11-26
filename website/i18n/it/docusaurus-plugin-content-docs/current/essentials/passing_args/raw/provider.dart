import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../first_request/raw/activity.dart';

/* SNIPPET START */

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

// Un provider "funzionale"
final activityProvider = FutureProvider.autoDispose((ref) async {
  // TODO: eseguire una richiesta di rete per ottenere un'attività.
  return fetchActivity();
});

// O in alternativa, un "notifier"
final activityProvider2 = AsyncNotifierProvider<ActivityNotifier, Activity>(
  ActivityNotifier.new,
);

class ActivityNotifier extends AsyncNotifier<Activity> {
  @override
  Future<Activity> build() async {
    // TODO: eseguire una richiesta di rete per ottenere un'attività.
    return fetchActivity();
  }
}
