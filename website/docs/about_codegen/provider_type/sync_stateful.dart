import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_stateful.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  String build() => 'Hello world';

//Add other methods that can mutate the state.
}
