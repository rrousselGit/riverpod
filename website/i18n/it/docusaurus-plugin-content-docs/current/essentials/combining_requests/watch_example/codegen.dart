// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final otherProvider = Provider<int>((ref) => 0);

const someStream = Stream<({double longitude, double latitude})>.empty();

/* SNIPPET START */
@riverpod
Stream<({double longitude, double latitude})> location(LocationRef ref) {
  // TO-DO: Restituire uno stream che ottiene la posizione corrente
  return someStream;
}

@riverpod
Future<List<String>> restaurantsNearMe(RestaurantsNearMeRef ref) async {
  // Usiamo "ref.watch" per ottenere l'ultima posizione.
  // Specificando ".future" dopo il provider il nostro codice aspetterà
  // che almeno una posizione sia disponibile
  final location = await ref.watch(locationProvider.future);

  // Possiamo quindi fare una richiesta di rete basata su questa posizione.
  // Per esempio potremmo usare le API di Google Map:
  // https://developers.google.com/maps/documentation/places/web-service/search-nearby
  final response = await http.get(
    Uri.https('maps.googleapis.com', 'maps/api/place/nearbysearch/json', {
      'location': '${location.latitude},${location.longitude}',
      'radius': '1500',
      'type': 'restaurant',
      'key': '<your api key>',
    }),
  );
  // Ottiene i nomi dei ristoranti dal JSON
  final json = jsonDecode(response.body) as Map;
  final results = (json['results'] as List).cast<Map<Object?, Object?>>();
  return results.map((e) => e['name']! as String).toList();
}
/* SNIPPET END */
