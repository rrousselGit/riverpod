// Regresion test for https://github.com/rrousselGit/riverpod/issues/2175
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'split2.dart';
part 'split.g.dart';

@riverpod
int counter2(Ref ref) => 0;
