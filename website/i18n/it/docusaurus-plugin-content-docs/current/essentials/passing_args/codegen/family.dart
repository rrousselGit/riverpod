import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../first_request/codegen/activity.dart';

part 'family.g.dart';

/* SNIPPET START */
@riverpod
Future<Activity> activity(
  ActivityRef ref,
  // Possiamo aggiungere argomenti al provider
  // Il tipo del parametro può essere qualsiasi cosa tu voglia.
  String activityType,
) async {
  // Possiamo usare l'argomento "activityType" per costruire l'URL
  // Questo punterà a "https://boredapi.com/api/activity?type=<activityType>"
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      // Nessun bisogno di codificare i parametri di query, la classe "Uri" lo fa al posto nostro.
      queryParameters: {'type': activityType},
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}
