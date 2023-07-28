// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../first_request/raw/activity.dart';

/* SNIPPET START */

// We define a record representing the parameters we want to pass to the provider.
// Making a typedef is optional but can make the code more readable.
typedef ActivityParameters = ({String type, int maxPrice});

final activityProvider = FutureProvider.autoDispose
    // We now use the newly defined record as the argument type.
    .family<Activity, ActivityParameters>((ref, arguments) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      queryParameters: {
        // Lastly, we can use the arguments to update our query parameters.
        'type': arguments.type,
        'price': arguments.maxPrice,
      },
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
});
