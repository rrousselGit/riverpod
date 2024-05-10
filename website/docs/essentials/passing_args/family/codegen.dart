// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../first_request/codegen/activity.dart';

part 'codegen.g.dart';

Future<Activity> fetchActivity() => throw UnimplementedError();

/* SNIPPET START */
@riverpod
Future<Activity> activity(
  ActivityRef ref,
  // {@template codegen_activityType}
  // We can add arguments to the provider.
  // The type of the parameter can be whatever you wish.
  // {@endtemplate}
  String activityType,
) async {
  // {@template codegen_get}
  // We can use the "activityType" argument to build the URL.
  // This will point to "https://boredapi.com/api/activity?type=<activityType>"
  // {@endtemplate}
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      // {@template codegen_query}
      // No need to manually encode the query parameters, the "Uri" class does it for us.
      // {@endtemplate}
      queryParameters: {'type': activityType},
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}

@riverpod
class ActivityNotifier2 extends _$ActivityNotifier2 {
  // {@template codegen_build}
  /// Notifier arguments are specified on the build method.
  /// There can be as many as you want, have any name, and even be optional/named.
  // {@endtemplate}
  @override
  Future<Activity> build(String activityType) async {
    // {@template codegen_argument}
    // Arguments are also available with "this.<argumentName>"
    // {@endtemplate}
    print(this.activityType);

    // {@template todo}
    // TODO: perform a network request to fetch an activity
    // {@endtemplate}
    return fetchActivity();
  }
}
