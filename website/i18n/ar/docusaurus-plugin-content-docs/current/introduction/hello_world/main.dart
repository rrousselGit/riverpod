// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  runApp(
    // {@template ProviderScope}
    // لكي تتمكن الأدوات (Widgets) من قراءة بيانات الموفرين،
    // نحتاج إلى تغليف التطبيق بأكمله في أداة "ProviderScope".
    // هنا سيتم تخزين حالة جميع الموفرين (Providers).
    // {@endtemplate}
    ProviderScope(child: MyApp()),
  );
}

// {@template ConsumerWidget}
// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
// {@endtemplate}
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('مثال')),
        body: Center(child: Text(value)),
      ),
    );
  }
}
