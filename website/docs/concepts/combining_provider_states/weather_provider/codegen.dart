import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
String city(Ref ref) => 'London';

class Weather {}

Future<Weather> fetchWeather({required String city}) async => Weather();
/* SNIPPET START */
@riverpod
Future<Weather> weather(Ref ref) {
  // We use `ref.watch` to listen to another provider, and we pass it the provider
  // that we want to consume. Here: cityProvider
  final city = ref.watch(cityProvider);

  // We can then use the result to do something based on the value of `cityProvider`.
  return fetchWeather(city: city);
}
