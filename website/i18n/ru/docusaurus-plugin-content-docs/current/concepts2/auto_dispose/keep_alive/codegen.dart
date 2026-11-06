import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<String> example(Ref ref) async {
  final response = await http.get(Uri.parse('https://example.com'));
  // {@template keepAlive}
  // Делаем provider "живым" только после успешного завершения запроса.
  // Если запрос завершится с ошибкой (и будет выброшено исключение),
  // то когда provider перестанет использоваться, его состояние будет уничтожено.
  // {@endtemplate}
  ref.keepAlive();

  // {@template closeLink}
  // С помощью `link` можно вернуть автоматическое освобождение ресурсов:
  // {@endtemplate}
  // link.close();

  return response.body;
}
