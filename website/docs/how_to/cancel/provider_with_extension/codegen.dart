import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../detail_screen/codegen.dart';
import '../extension.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Brewery> brewery(Ref ref) async {
  // {@template client}
  // We obtain an HTTP client using the extension we created earlier.
  // {@endtemplate}
  final client = await ref.getDebouncedHttpClient();

  // {@template get}
  // We now use the client to make the request instead of the "get" function.
  // Our request will naturally be debounced and be cancelled if the user
  // leaves the page.
  // {@endtemplate}
  final response = await client.get(
    Uri.https('api.openbrewerydb.org', '/v1/breweries/random'),
  );

  final json = (jsonDecode(response.body) as List).first as Map;
  return Brewery.fromJson(Map.from(json));
}
/* SNIPPET END */
