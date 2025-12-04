// IMPORTANT: Any change to this file must also be applied to:
// - The DartPad embed gist
//   https://gist.github.com/rrousselGit/6bf918e3fc97a40b53d1ea80fd937146
// - The website tutorial
//   https://riverpod.dev/docs/tutorials/first_app

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dio = Dio();

Future<Joke> fetchRandomJoke() async {
  // Fetching a random joke from a public API
  final response = await dio.get<Map<String, Object?>>(
    'https://official-joke-api.appspot.com/random_joke',
  );

  return Joke.fromJson(response.data!);
}

final randomJokeProvider = FutureProvider<Joke>((ref) {
  // Using the fetchRandomJoke function to get a random joke
  return fetchRandomJoke();
});

class Joke {
  Joke({
    required this.type,
    required this.setup,
    required this.punchline,
    required this.id,
  });

  factory Joke.fromJson(Map<String, Object?> json) {
    return Joke(
      type: json['type']! as String,
      setup: json['setup']! as String,
      punchline: json['punchline']! as String,
      id: json['id']! as int,
    );
  }

  final String type;
  final String setup;
  final String punchline;
  final int id;
}
