import 'package:riverpod/riverpod.dart';

final normalProvider = Provider((ref) => 0);
final futureProvider = FutureProvider((ref) => 1);
final familyProviders = Provider.family((ref, anyNumber) => 2);

class SampleClass {
  static final normalProvider = Provider((ref) => 0);
  static final futureProvider = FutureProvider((ref) => 1);
  static final familyProviders = Provider.family((ref,anyNumber) => 2);
}
