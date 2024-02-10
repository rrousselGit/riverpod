// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../first_request/raw/activity.dart';

/* SNIPPET START */

// Definiamo un record che rappresenta gli argomenti che vogliamo passare al provider.
// Renderlo un typedef è opzionale ma può rendere il codice più leggibile.
typedef ActivityParameters = ({String type, int maxPrice});

final activityProvider = FutureProvider.autoDispose
    // Possiamo usare il record definito prima come tipo degli argomenti.
    .family<Activity, ActivityParameters>((ref, arguments) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'boredapi.com',
      path: '/api/activity',
      queryParameters: {
        // Infine, possiamo usare gli argomenti per aggiornare i nostri parametri di query.
        'type': arguments.type,
        'price': arguments.maxPrice,
      },
    ),
  );
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
});
