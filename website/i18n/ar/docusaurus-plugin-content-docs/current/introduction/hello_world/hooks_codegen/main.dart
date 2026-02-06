// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

// {@template HookConsumerWidget}
// قم بالتوريث (Extend) من HookConsumerWidget بدلا من StatelessWidget, والذي يتم توفيره بواسطة Riverpod
// {@endtemplate}
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // {@template hooksCodegen_counter}
    // يمكننا استخدام الخطافات داخل عنصر واجهة المستخدم HookConsumerWidget
    // {@endtemplate}
    final counter = useState(0);

    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('مثال')),
        body: Center(child: Text('$value ${counter.value}')),
      ),
    );
  }
}
