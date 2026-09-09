
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create.g.dart';

/* SNIPPET START */

@riverpod
Future<String> breweryName(Ref ref) async {
  final response = await http.get(
    Uri.https('api.openbrewerydb.org', '/v1/breweries/random'),
  );
  final json = jsonDecode(response.body) as List;
  return (json.first as Map)['name']! as String;
}
