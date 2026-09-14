import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../activity/raw.dart';

/* SNIPPET START */
final breweryProvider = FutureProvider.autoDispose<Brewery>((ref) async {
  final response = await http.get(
    Uri.https('api.openbrewerydb.org', '/v1/breweries/random'),
  );

  final json = (jsonDecode(response.body) as List).first as Map;
  return Brewery.fromJson(json);
});
/* SNIPPET END */
