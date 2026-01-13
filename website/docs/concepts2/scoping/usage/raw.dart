
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  User();

  factory User.fromJson(_) => User();
}

/* SNIPPET START */
final currentItemIdProvider = Provider<String?>(
  // highlight-next-line
  dependencies: const [],
  (ref) => null,
);
