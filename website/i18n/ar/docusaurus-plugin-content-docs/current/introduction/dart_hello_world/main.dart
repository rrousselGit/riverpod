// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// {@template helloWorld}
// نقوم بإنشاء "Provider"، والذي سيخزن قيمة ("مرحبا بالعالم").
// نستخدم Provider
// يسمح لنا ذلك بمحاكاة/تغيير القيمة المعروضة.
// {@endtemplate}
@riverpod
String helloWorld(Ref ref) {
  return 'مرحبا بالعالم!';
}

void main() {
  // {@template container}
  // هذا الكائن هو المكان الذي سيتم فيه تخزين حالة مزودي الخدمة لدينا.
  // {@endtemplate}
  final container = ProviderContainer();

  // {@template value}
  // بفضل "container"، يمكننا قراءة بيانات مزود الخدمة لدينا.
  // {@endtemplate}
  final value = container.read(helloWorldProvider);

  print(value); // مرحبا بالعالم!
}
