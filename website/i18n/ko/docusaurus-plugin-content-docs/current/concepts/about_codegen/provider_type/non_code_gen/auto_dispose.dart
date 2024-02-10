import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
// 자동폐기(autodispose) 프로바이더
final example1Provider = Provider.autoDispose<String>((ref) {
  return 'foo';
});

// 비동기 자동폐기(autodispose) 프로바이더
final example2Provider = Provider<String>((ref) {
  return 'foo';
});
