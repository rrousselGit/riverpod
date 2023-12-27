import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
// 一个急于初始化的提供者程序。
final exampleProvider = FutureProvider<String>((ref) async => 'Hello world');
/* SNIPPET END */
