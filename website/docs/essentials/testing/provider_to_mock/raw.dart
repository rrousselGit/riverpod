import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
// {@template provider}
// An eagerly initialized provider.
// {@endtemplate}
final exampleProvider = FutureProvider<String>((ref) async => 'Hello world');
/* SNIPPET END */
