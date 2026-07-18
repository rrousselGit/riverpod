import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

late WidgetRef ref;

/* SNIPPET START */
@riverpod
String label(Ref ref, String userName) {
  return 'Hello $userName';
}

// ...

void onTap() {
  // {@template invalidateAll}
  // Инвалидировать все возможные комбинации параметров этого provider.
  // {@endtemplate}
  ref.invalidate(labelProvider);
  // {@template invalidate}
  // Инвалидировать только конкретную комбинацию параметров.
  // {@endtemplate}
  ref.invalidate(labelProvider('John'));
}

/* SNIPPET END */
