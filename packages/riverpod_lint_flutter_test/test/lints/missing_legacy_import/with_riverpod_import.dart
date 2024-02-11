import 'package:riverpod/legacy.dart';

// ignore_for_file: undefined_function, undefined_identifier

final p = StateProvider((ref) => 0);

final p2 = StateProvider.autoDispose((ref) => 0);

// expect_lint: missing_legacy_import
final p3 = ChangeNotifierProvider((ref) => 0);

final p4 = StateNotifierProvider<StateNotifier<int>, int>((ref) {
  throw UnimplementedError();
});
