// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final provider = FutureProvider.autoDispose<String>((ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // {@template keepAlive}
  // Делаем provider "живым" только после успешного завершения запроса.
  // Если запрос завершится с ошибкой (и будет выброшено исключение),
  // то когда provider перестанет использоваться, его состояние будет уничтожено.
  // {@endtemplate}
  final link = ref.keepAlive();

  // {@template closeLink}
  // С помощью `link` можно вернуть автоматическое освобождение ресурсов:
  // {@endtemplate}
  // link.close();

  return response.body;
});
/* SNIPPET END */
