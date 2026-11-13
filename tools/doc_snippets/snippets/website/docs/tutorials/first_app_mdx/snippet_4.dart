// GENERATED from website/docs/tutorials/first_app.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

// The snippet that defines randomJokeProvider, for the ones that use it.
import 'random_joke_provider.dart';

final dio = Dio();

class Joke {
  factory Joke.fromJson(Map<String, Object?> json) {
    throw UnimplementedError();
  }
}

late WidgetRef ref;
late AsyncValue<String> asyncValue;
late AsyncValue<Joke> randomJoke;

dynamic snippet() async => ElevatedButton(
  // highlight-next-line
  onPressed: () => ref.invalidate(randomJokeProvider),
  child: const Text('Get another joke'),
);
