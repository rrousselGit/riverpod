// ignore_for_file: unnecessary_this, avoid_print

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../first_request/raw/activity.dart';

FutureOr<Activity> fetchActivity(String activityType) => throw UnimplementedError();

/* SNIPPET START */
// Un provider "funzionale"
final activityProvider = FutureProvider.autoDispose
    // Usiamo il modificatore ".family"
    // Il tipo generico "String" corrisponde al tipo di argomento.
    // Il nostro provider ora riceve un argomento extra oltre "ref": la tipologia di attività.
    .family<Activity, String>((ref, activityType) async {
  // TODO: eseguire una richiesta di rete per ottenere un'attività.
  return fetchActivity(activityType);
});

// Un provider "notifier"
final activityProvider2 = AsyncNotifierProvider.autoDispose
    // Di nuovo, usiamo il modificatore ".family" e specifichiamo "String" come tipo di argomento.
    .family<ActivityNotifier, Activity, String>(
  ActivityNotifier.new,
);

// Quando si usa ".family" con i notifier abbiamo bisogno di cambiare la sottoclasse del notifier:
// AsyncNotifier -> FamilyAsyncNotifier
// AutoDisposeAsyncNotifier -> AutoDisposeFamilyAsyncNotifier
class ActivityNotifier extends AutoDisposeFamilyAsyncNotifier<Activity, String> {
  /// Gli argomenti della famiglia sono passati al metodo build e accessibili tramite this.arg
  @override
  Future<Activity> build(String activityType) async {
    print(this.arg);

    // TODO: eseguire una richiesta di rete per ottenere un'attività.
    return fetchActivity(activityType);
  }
}
