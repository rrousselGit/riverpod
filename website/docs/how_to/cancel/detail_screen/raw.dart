import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/* SNIPPET START */
class Brewery {
  Brewery({
    required this.name,
    required this.breweryType,
    required this.city,
    required this.country,
  });

  factory Brewery.fromJson(Map<Object?, Object?> json) {
    return Brewery(
      name: json['name']! as String,
      breweryType: json['brewery_type']! as String,
      city: json['city']! as String,
      country: json['country']! as String,
    );
  }

  final String name;
  final String breweryType;
  final String city;
  final String country;
}

final breweryProvider = FutureProvider.autoDispose<Brewery>((ref) async {
  final response = await http.get(
    Uri.https('api.openbrewerydb.org', '/v1/breweries/random'),
  );

  final json = (jsonDecode(response.body) as List).first as Map;
  return Brewery.fromJson(json);
});

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
