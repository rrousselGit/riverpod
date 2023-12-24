// ignore_for_file: unused_local_variable, avoid_multiple_declarations_per_line, omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors, body_might_complete_normally_nullable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class User {
  late String firstName, lastName;
}

final userProvider = FutureProvider(
  (ref) => User()
    ..firstName = 'John'
    ..lastName = 'Doe',
);
/* SNIPPET START */
@riverpod
Object? example(ExampleRef ref) async {
  // 等待 user 可用，并只监听 "firstName" 属性
  final firstName = await ref.watch(
    userProvider.selectAsync((it) => it.firstName),
  );

  // TODO 使用 "firstName" 获取其他信息
}
/* SNIPPET END */
