// GENERATED from tools/generate_providers/src/docs.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final dio = Dio();
final httpClient = Dio();

class User {
  User(this.name);

  final String name;
}

class UserRepository {
  Future<User> fetch(int userId) async => User('John');
}

final userRepositoryProvider = Provider((ref) => UserRepository());

class Configurations {
  Configurations(this.host);

  final String host;
}

class Repository {
  Repository({required this.host});

  final String host;
}

class Message {
  Message.fromJson(Map<String, Object?> json);
}

class ComplexParameter {}

class Value {
  Value(this.param);

  final ComplexParameter param;
}

final titleFamily = Provider.family<String, Locale>((ref, locale) {
  if (locale == const Locale('en')) {
    return 'English title';
  } else if (locale == const Locale('fr')) {
    return 'Titre Français';
  }
  throw UnsupportedError('Unsupported locale: $locale');
});

// ...

Widget build(BuildContext context, WidgetRef ref) {
  final locale = Localizations.localeOf(context);

  // Obtains the title based on the current Locale.
  // Will automatically update the title when the Locale changes.
  final title = ref.watch(titleFamily(locale));

  return Text(title);
}
