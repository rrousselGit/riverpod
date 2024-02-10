import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family.g.dart';

/* SNIPPET START */
@riverpod
String example(ExampleRef ref, int param) => 'Hello $param';
