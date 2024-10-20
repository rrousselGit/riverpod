import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'another.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(Ref ref) => 0;
