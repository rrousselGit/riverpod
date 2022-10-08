import 'package:riverpod/riverpod.dart';

/// A non-generated provider.
final nonGeneratedProvider = Provider((ref) {
  return 'normalProvider';
});

/// Another non-generated provider that depends on [nonGeneratedProvider].
final nonGeneratedProvider2 = Provider((ref) {
  return ref.watch(nonGeneratedProvider);
});
