// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

final otherProvider = Provider<int>((ref) => 0);

const someStream = Stream<({double longitude, double latitude})>.empty();

/* SNIPPET START */
final locationProvider =
    StreamProvider<({double longitude, double latitude})>((ref) {
  // TO-DO: Return a stream which obtains the current location
  return someStream;
});

final restaurantsNearMeProvider = FutureProvider<List<String>>((ref) async {
  // We use "ref.watch" to obtain the latest location.
  // By specifying that ".future" after the provider, our code will wait
  // for at least one location to be available.
  final location = await ref.watch(locationProvider.future);

  // We can now make a network request based on that location.
  // For example, we could use the Google Map API:
  // https://developers.google.com/maps/documentation/places/web-service/search-nearby
  final response = await http.get(
    Uri.https('maps.googleapis.com', 'maps/api/place/nearbysearch/json', {
      'location': '${location.latitude},${location.longitude}',
      'radius': '1500',
      'type': 'restaurant',
      'key': '<your api key>',
    }),
  );
  // Obtain the restaurant names from the JSON
  final json = jsonDecode(response.body) as Map;
  final results = (json['results'] as List).cast<Map<Object?, Object?>>();
  return results.map((e) => e['name']! as String).toList();
});
/* SNIPPET END */
