import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_class.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  String build(
    int param1, {
    String param2 = 'foo',
  }) {
    return 'Hello $param1 & param2';
  }

  // Add methods to mutate the state
}
