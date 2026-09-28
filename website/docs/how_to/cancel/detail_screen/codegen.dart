import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.freezed.dart';
part 'codegen.g.dart';

/* SNIPPET START */
@freezed
sealed class Brewery with _$Brewery {
  factory Brewery({
    required String name,
    @JsonKey(name: 'brewery_type') required String breweryType,
    required String city,
    required String country,
  }) = _Brewery;

  factory Brewery.fromJson(Map<String, dynamic> json) =>
      _$BreweryFromJson(json);
}

@riverpod
Future<Brewery> brewery(Ref ref) async {
  final response = await http.get(
    Uri.https('api.openbrewerydb.org', '/v1/breweries/random'),
  );

  final json = (jsonDecode(response.body) as List).first as Map;
  return Brewery.fromJson(Map.from(json));
}

class DetailPageView extends ConsumerWidget {
  const DetailPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brewery = ref.watch(breweryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail page'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(breweryProvider.future),
        child: ListView(
          children: [
            switch (brewery) {
              AsyncValue(:final value?) => Text(value.name),
              AsyncValue(:final error?) => Text('Error: $error'),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ],
        ),
      ),
    );
  }
}
