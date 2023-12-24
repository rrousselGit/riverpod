import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
// Un provider inizializzato anticipatamente
final exampleProvider = FutureProvider<String>((ref) async => 'Hello world');
/* SNIPPET END */
