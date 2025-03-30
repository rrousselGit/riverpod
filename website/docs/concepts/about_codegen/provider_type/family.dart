import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family.g.dart';

/* SNIPPET START */
@riverpod
String example(Ref ref, int param) => 'Hello $param';
