import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
// An eagerly initialized provider.
final exampleProvider = FutureProvider<String>((ref) async => 'Hello world');
/* SNIPPET END */
