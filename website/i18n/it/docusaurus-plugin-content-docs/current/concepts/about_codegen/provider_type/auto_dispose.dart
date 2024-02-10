import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose.g.dart';

/* SNIPPET START */
// Provider autoDispose (keepAlive è false di default)
@riverpod
String example1(Example1Ref ref) => 'foo';

// Provider non autoDispose
@Riverpod(keepAlive: true)
String example2(Example2Ref ref) => 'foo';
