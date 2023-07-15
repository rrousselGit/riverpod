import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_class.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  String build() {
    return 'foo';
  }

  // Add methods to mutate the state
}
