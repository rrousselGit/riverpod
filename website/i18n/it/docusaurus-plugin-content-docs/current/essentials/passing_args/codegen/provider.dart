// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../first_request/codegen/activity.dart';

// Necessario per la generazione di codice
part 'provider.g.dart';

FutureOr<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
// Un provider "funzionale"
@riverpod
Future<Activity> activity(ActivityRef ref) async {
  // TODO: eseguire una richiesta di rete per ottenere un'attività.
  return fetchActivity();
}

// O in alternativa, un "notifier"
@riverpod
class ActivityNotifier2 extends _$ActivityNotifier2 {
  /// Notifier arguments are specified on the build method.
  /// There can be as many as you want, have any name, and even be optional/named.
  @override
  Future<Activity> build(String activityType) async {
    // Gli argomenti sono disponibili anche tramite "this.<argumentName>"
    print(this.activityType);

    // TODO: eseguire una richiesta di rete per ottenere un'attività.
    return fetchActivity();
  }
}
