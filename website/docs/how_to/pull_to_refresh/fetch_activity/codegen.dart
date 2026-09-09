import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../activity/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Brewery> brewery(Ref ref) async {
  final response = await http.get(
    Uri.https('api.openbrewerydb.org', '/v1/breweries/random'),
  );

  final json = (jsonDecode(response.body) as List).first as Map;
  return Brewery.fromJson(Map.from(json));
}
/* SNIPPET END */
