// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/creating_a_provider/codegen.dart';

class MyValue {}

/* SNIPPET START */

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We can use the builders provided by both packages
    return Consumer(
      builder: (context, ref, child) {
        return HookBuilder(builder: (context) {
          final counter = useState(0);
          final value = ref.watch(myProvider);

          return Text('Hello $counter $value');
        });
      },
    );
  }
}
