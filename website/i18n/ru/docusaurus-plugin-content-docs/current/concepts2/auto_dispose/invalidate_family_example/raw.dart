import 'package:flutter_riverpod/flutter_riverpod.dart';

late WidgetRef ref;

/* SNIPPET START */
final provider = Provider.autoDispose.family<String, String>((ref, name) {
  return 'Hello $name';
});

// ...

void onTap() {
  // {@template invalidateAll}
  // Инвалидировать все возможные комбинации параметров этого provider.
  // {@endtemplate}
  ref.invalidate(provider);
  // {@template invalidate}
  // Инвалидировать только конкретную комбинацию параметров.
  // {@endtemplate}
  ref.invalidate(provider('John'));
}

/* SNIPPET END */
