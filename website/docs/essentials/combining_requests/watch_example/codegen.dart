// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final otherProvider = Provider<int>((ref) => 0);

const someStream = Stream<({double longitude, double latitude})>.empty();

/* SNIPPET START */
@riverpod
Stream<({double longitude, double latitude})> location(LocationRef ref) {
  // {@template provider}
  // TO-DO: Return a stream which obtains the current location
  // {@endtemplate}
  return someStream;
}

@riverpod
Future<List<String>> restaurantsNearMe(RestaurantsNearMeRef ref) async {
  // {@template watch}
  // We use "ref.watch" to obtain the latest location.
  // By specifying that ".future" after the provider, our code will wait
  // for at least one location to be available.
  // {@endtemplate}
  final location = await ref.watch(locationProvider.future);

  // {@template get}
  // We can now make a network request based on that location.
  // For example, we could use the Google Map API:
  // {@endtemplate}
  // https://developers.google.com/maps/documentation/places/web-service/search-nearby
  final response = await http.get(
    Uri.https('maps.googleapis.com', 'maps/api/place/nearbysearch/json', {
      'location': '${location.latitude},${location.longitude}',
      'radius': '1500',
      'type': 'restaurant',
      'key': '<your api key>',
    }),
  );
  // {@template jsonDecode}
  // Obtain the restaurant names from the JSON
  // {@endtemplate}
  final json = jsonDecode(response.body) as Map;
  final results = (json['results'] as List).cast<Map<Object?, Object?>>();
  return results.map((e) => e['name']! as String).toList();
}
/* SNIPPET END */
